from const import EstimatorConstant
import numpy as np
import numpy.typing as npt
from typing import Annotated, Literal, TypeVar, Tuple
import dataclasses

DType = TypeVar("DType", bound=np.generic)

Array2 = Annotated[npt.NDArray[DType], Literal[2]]
Array4 = Annotated[npt.NDArray[DType], Literal[4]]
Array5 = Annotated[npt.NDArray[DType], Literal[5]]
Array5x5 = Annotated[npt.NDArray[DType], Literal[5, 5]]
Array5x2 = Annotated[npt.NDArray[DType], Literal[5, 2]]
Array2x2 = Annotated[npt.NDArray[DType], Literal[2, 2]]

STATE_TYPE = Array5[np.float32]
INPUT_TYPE = Array2[np.float32]
MEASUREMENT_TYPE = Array4[np.float32]
PNOISE_TYPE = Array2[np.float32]
MNOISE_TYPE = Array4[np.float32]


@dataclasses.dataclass(frozen=True)
class EKFParameters:
    pass


@dataclasses.dataclass(frozen=True)
class PFParameters:
    num_particles: int = 800
    roughening_factor: float = 0.001


def dynamics(x: STATE_TYPE, u: INPUT_TYPE, v: PNOISE_TYPE, Ts: float) -> STATE_TYPE:
    px = x[0]
    py = x[1]
    psi = x[2]
    tau = x[3]
    l = x[4]
    beta = u[0]
    uc = u[1]
    v_beta = v[0]
    v_uc = v[1]

    # fmt: off
    return np.array([
        px + tau * Ts * np.cos(psi + beta),
        py + tau * Ts * np.sin(psi + beta),
        psi + tau * Ts * np.sin(beta + v_beta) / l,
        tau + Ts * (uc + v_uc),
        l,
    ])
    # fmt: on


class EKF:
    """
    Extended Kalman Filter class

    Args:
        estimator_constant : EstimatorConstant
            Constants known to the estimator.
    """

    def __init__(
        self,
        estimator_constant: EstimatorConstant,
    ):
        self.constant = estimator_constant
        self.Q = np.diag([self.constant.sigma_beta**2, self.constant.sigma_uc**2])
        self.H = np.eye(4, 5, dtype=np.float32)
        self.M = np.eye(4, dtype=np.float32)

    def initialize(
        self,
    ) -> Tuple[np.ndarray, np.ndarray]:
        """
        Initialize the estimator with the mean and covariance of the initial
        estimate.

        Returns:
            xm : np.ndarray, dim: (num_states,)
                The mean of the initial state estimate. The order of states is
                given by x = [p_x, p_y, psi, tau, l].
            Pm : np.ndarray, dim: (num_states, num_states)
                The covariance of the initial state estimate. The order of
                states is given by x = [p_x, p_y, psi, tau, l].
        """
        # using method of moments to initialize the state
        length_mean = (self.constant.l_lb + self.constant.l_ub) / 2
        tau_mean = (self.constant.start_velocity_bound + 0) / 2
        R = self.constant.start_radius_bound
        xm = np.array([0, 0, 0, tau_mean, length_mean], dtype=np.float32)
        Pm = np.diag(
            [
                R / 2,  # p_x
                R / 2,  # p_y
                2 * self.constant.start_heading_bound / np.sqrt(12),  # psi
                self.constant.start_velocity_bound / np.sqrt(12),  # tau
                (self.constant.l_ub - self.constant.l_lb) / np.sqrt(12),  # l
            ]
        )

        return xm, Pm

    def measurement(self, x: STATE_TYPE, w: MNOISE_TYPE) -> MEASUREMENT_TYPE:
        # return self.H @ x + w
        return x[:4] + w

    def jacobian_dynamics_states(
        self, xm: STATE_TYPE, mapped_inputs: INPUT_TYPE
    ) -> Array5x5[np.float32]:
        """\frac{\partial q_{k-1}(x, 0)}{\partial x}_{xm} Jacobian of the
        dynamics function q_{k-1}(x, 0) at the previous state estimate xm

        Args:
            xm (Array5[np.float32]): _description_
            mapped_inputs (Array2[np.float32]): u_del transformed to beta is provided

        Returns:
            Array4x4[np.float32]: _description_
        """
        psim_prev = xm[2]
        taum_prev = xm[3]
        lm_prev = xm[4]
        beta = mapped_inputs[0]
        Ts = self.constant.Ts
        sin_psim_prev_plus_beta = np.sin(psim_prev + beta)
        cos_psim_prev_plus_beta = np.cos(psim_prev + beta)
        sin_beta = np.sin(beta)

        # fmt: off
        return np.array(
            [
                [1, 0, -Ts * taum_prev * sin_psim_prev_plus_beta, Ts * cos_psim_prev_plus_beta, 0],
                [0, 1, Ts * taum_prev * cos_psim_prev_plus_beta, Ts * sin_psim_prev_plus_beta, 0],
                [0, 0, 1, Ts * sin_beta / (lm_prev), -taum_prev * sin_beta / (lm_prev ** 2)],
                [0, 0, 0, 1, 0],
                [0, 0, 0, 0, 1],
            ],
            dtype=np.float32,
        )
        # fmt: on

    def jacobian_dynamics_inputs(
        self, xm: STATE_TYPE, mapped_inputs: INPUT_TYPE
    ) -> Array5x2[np.float32]:
        psim_prev = xm[2]
        taum_prev = xm[3]
        lm_prev = xm[4]
        beta = mapped_inputs[0]
        Ts = self.constant.Ts

        # fmt: off
        return np.array([
            [-Ts * taum_prev * np.sin(psim_prev + beta), 0],
            [Ts * taum_prev * np.cos(psim_prev + beta), 0],
            [Ts * taum_prev * np.cos(beta) / lm_prev, 0],
            [0, Ts],
            [0, 0],
        ])
        # fmt: on

    def jacobian_dynamics_process_noise(
        self, xm: STATE_TYPE, mapped_inputs: INPUT_TYPE
    ) -> Array5x2[np.float32]:
        taum_prev = xm[3]
        lm_prev = xm[4]
        beta = mapped_inputs[0]
        Ts = self.constant.Ts

        # fmt: off
        return np.array([
            [0, 0],
            [0, 0],
            [Ts * taum_prev * np.cos(beta) / lm_prev, 0],
            [0, Ts],
            [0, 0],
        ])
        # fmt: on

    def estimate(
        self,
        xm_prev: np.ndarray,
        Pm_prev: np.ndarray,
        inputs: np.ndarray,
        measurement: np.ndarray,
    ) -> Tuple[np.ndarray, np.ndarray]:
        """
        Estimate the state of the vehicle.

        Args:
            xm_prev : STATE_TYPE, dim: (num_states,)
                The mean of the previous posterior state estimate xm(k-1). The
                order of states is given by x = [p_x, p_y, psi, tau, l].
            Pm_prev : Array5x5[np.float32], dim: (num_states, num_states)
                The covariance of the previous posterior state estimate Pm(k-1).
                The order of states is given by x = [p_x, p_y, psi, tau, l].
            inputs : INPUT_TYPE, dim: (num_inputs,)
                System inputs from time step k-1, u(k-1). The order of the
                inputs is given by u = [u_delta, u_c].
            measurement : MEASUREMENT_TYPE, dim: (num_measurement,)
                Sensor measurements from time step k, z(k). The order of the
                measurements is given by z = [z_px, z_py, z_psi, z_tau].

        Returns:
            xm : np.ndarray, dim: (num_states,)
                The mean of the posterior estimate xm(k). The order of states is
                given by x = [p_x, p_y, psi, tau, l].
            Pm : np.ndarray, dim: (num_states, num_states)
                The covariance of the posterior estimate Pm(k). The order of
                states is given by x = [p_x, p_y, psi, tau, l].
        """
        mapped_inputs = np.array(
            [np.arctan(0.5 * np.tan(inputs[0])), inputs[1]], dtype=np.float32
        )  # NOTE: treating this as the new input can lead to loss in numerical precision, remember if bad performance
        zero_pnoise = np.zeros(2, dtype=np.float32)
        zero_mnoise = np.zeros(4, dtype=np.float32)

        # Predict step
        A = self.jacobian_dynamics_states(xm_prev, mapped_inputs)
        L = self.jacobian_dynamics_process_noise(xm_prev, mapped_inputs)
        xp = dynamics(xm_prev, mapped_inputs, zero_pnoise, self.constant.Ts)
        Pp = A @ Pm_prev @ A.T + L @ self.Q @ L.T

        # Measurement update step
        # because h is linear, we don't need to linearize
        pred_measurement = self.measurement(xp, zero_mnoise)
        R = np.diag(
            [
                self.constant.sigma_GPS**2,
                self.constant.sigma_GPS**2,
                self.constant.sigma_psi**2,
                self.constant.sigma_tau**2,
            ]
        )
        nan_mask = np.isnan(measurement)
        # make nan measurements have a very high variance
        R[nan_mask, nan_mask] = 1e40
        # replace NaNs with predicted values
        measurement[nan_mask] = pred_measurement[nan_mask]

        K = (
            Pp
            @ self.H.T
            @ np.linalg.inv(self.H @ Pp @ self.H.T + self.M @ R @ self.M.T)
        )
        xm = xp + K @ (measurement - pred_measurement)
        Pm = (np.eye(5, dtype=np.float32) - K @ self.H) @ Pp

        return xm, Pm


class PF:
    """
    Particle Filter class

    Args:
        estimator_constant : EstimatorConstant
            Constants known to the estimator.
        noise : str
            Type of noise, either "Gaussian" or "Non-Gaussian".
    """

    def __init__(
        self,
        estimator_constant: EstimatorConstant,
        noise: str,
    ):
        self.constant = estimator_constant
        self.num_particles = PFParameters.num_particles
        if noise == "Gaussian":
            self.noise_sampler = self.sample_gaussian_noise
            self.likelihood_func = self.gaussian_likelihood
        elif noise == "Non-Gaussian":
            self.noise_sampler = self.sample_nongaussian_noise
            self.likelihood_func = self.nongaussian_likelihood
        else:
            raise ValueError(
                "Noise type not supported, should be either Gaussian or Non-Gaussian!"
            )

    def initialize(self) -> np.ndarray:
        """
        Initialize the estimator with the particles.

        Returns:
            particles: np.ndarray, dim: (num_states, num_particles)
                The particles corresponding to the initial state estimate. The
                order of states is given by x = [p_x, p_y, psi, tau, l].
        """
        R = self.constant.start_radius_bound
        random_numbers = np.random.rand(4, self.num_particles)
        r = R * np.sqrt(random_numbers[0])
        theta = 2 * np.pi * random_numbers[1]
        px = r * np.cos(theta)
        py = r * np.sin(theta)
        psi = self.constant.start_heading_bound * (2 * random_numbers[2] - 1) * np.pi
        tau = self.constant.start_velocity_bound * (2 * random_numbers[3] - 1)
        l = np.linspace(self.constant.l_lb, self.constant.l_ub, self.num_particles)
        particles = np.array([px, py, psi, tau, l], dtype=np.float32)
        return particles

    def calculate_wp_log(self, wp: float, sigma: float) -> float:
        num = np.sqrt(3) * wp / 2
        den = sigma / 2
        return np.log(
            (1 / (np.sqrt(2 * np.pi) * sigma))
            * (
                np.exp(-0.5 * ((wp - num) / den) ** 2)
                + np.exp(-0.5 * ((wp + num) / den) ** 2)
            )
        )

    def calculate_gaussian_log(self, w: float, sigma: float) -> float:
        return np.log(
            (1 / (np.sqrt(2 * np.pi) * sigma)) * np.exp(-0.5 * (w / sigma) ** 2)
        )

    def calculate_uniform_log(self, w: float, upper_limit: float) -> float:
        pdf = 1 / (2 * upper_limit)
        pdf_values = pdf * (np.abs(w) <= upper_limit)
        return np.log(pdf_values + 1e-12)  # add small value to avoid log(0)

    def get_betas(self, measurement: np.ndarray, xp: np.ndarray) -> np.ndarray:
        nan_mask = np.isnan(measurement)
        xp = xp[:4]  # ignore length state
        measurement[nan_mask] = xp[nan_mask, 0]  # replace NaNs with random xp
        parameters = np.array(
            [
                self.constant.sigma_GPS,
                self.constant.sigma_GPS,
                self.constant.sigma_psi,
                self.constant.sigma_tau,
            ]
        )
        parameters[nan_mask] = 1e40  # set NaN variances to a large value

        # note that likelihoods will be array of size num_particles
        # independent components
        likelihoods = self.likelihood_func(measurement, xp, parameters)
        return likelihoods

    def sample_gaussian_noise(self, Q: Array2x2[np.float32]) -> PNOISE_TYPE:
        uniform_noise = np.sqrt(3) * (
            np.random.rand(2, self.num_particles) * 2 - 1
        )  # uniform noise in [-1, 1]
        pnoise = Q.T @ uniform_noise
        return pnoise

    def sample_nongaussian_noise(self, Q: Array2x2[np.float32]) -> PNOISE_TYPE:
        normalized_noise = np.random.randn(2, self.num_particles)
        pnoise = Q.T @ normalized_noise
        return pnoise

    def gaussian_likelihood(
        self,
        z: Array4[np.float32],
        x: Array4[np.float32],
        parameters: Array4[np.float32],
    ):
        likelihoods = np.exp(
            self.calculate_gaussian_log(z[0] - x[0], parameters[0])
            + self.calculate_gaussian_log(z[1] - x[1], parameters[1])
            + self.calculate_gaussian_log(z[2] - x[2], parameters[2])
            + self.calculate_gaussian_log(z[3] - x[3], parameters[3])
        )
        return likelihoods / np.sum(likelihoods)

    def nongaussian_likelihood(
        self,
        z: Array4[np.float32],
        x: Array4[np.float32],
        parameters: Array4[np.float32],
    ):
        likelihoods = np.exp(
            self.calculate_wp_log(z[0] - x[0], parameters[0])
            + self.calculate_wp_log(z[1] - x[1], parameters[1])
            + self.calculate_uniform_log(z[2] - x[2], np.sqrt(3) * parameters[2])
            + self.calculate_uniform_log(z[3] - x[3], np.sqrt(3) * parameters[3])
        )
        return likelihoods / np.sum(likelihoods)

    def estimate(
        self,
        particles: np.ndarray,
        inputs: np.ndarray,
        measurement: np.ndarray,
    ) -> np.ndarray:
        """
        Estimate the state of the vehicle.

        Args:
            particles : np.ndarray, dim: (num_states, num_particles)
                The posteriors of the particles of the previous time step k-1.
                The order of states is given by x = [p_x, p_y, psi, tau, l].
            inputs : np.ndarray, dim: (num_inputs,)
                System inputs from time step k-1, u(k-1). The order of the
                inputs is given by u = [u_delta, u_c].
            measurement : np.ndarray, dim: (num_measurement,)
                Sensor measurements from time step k, z(k). The order of the
                measurements is given by z = [z_px, z_py, z_psi, z_tau].

        Returns:
            posteriors : np.ndarray, dim: (num_states, num_particles)
                The posterior particles at time step k. The order of states is
                given by x = [p_x, p_y, psi, tau, l].
        """
        Q = np.diag([self.constant.sigma_beta, self.constant.sigma_uc])

        pnoise = self.noise_sampler(Q)

        # prior update
        # this represents a batch of possible predicted states given some sampled noise
        xp = dynamics(particles, inputs, pnoise, self.constant.Ts)
        # measurement update
        betas = self.get_betas(measurement, xp)
        # resampling
        random_numbers = np.random.rand(self.num_particles)
        indices = np.searchsorted(np.cumsum(betas), random_numbers)
        posteriors = xp[:, indices]
        # roughening
        max_values = np.max(posteriors, axis=1)
        min_values = np.min(posteriors, axis=1)
        peakToPeak = np.abs(max_values - min_values)
        roughening_factor = PFParameters.roughening_factor * self.num_particles**-0.2
        sigma = np.diag(peakToPeak[:4] * roughening_factor)
        noise = np.random.multivariate_normal(
            mean=np.zeros(4, dtype=np.float32), cov=sigma, size=self.num_particles
        ).T
        lnoise = np.random.normal(
            0, PFParameters.roughening_factor, size=self.num_particles
        )
        noise = np.vstack((noise, lnoise))
        posteriors += noise
        # clip the length state to the bounds
        posteriors[4] = np.clip(posteriors[4], self.constant.l_lb, self.constant.l_ub)

        return posteriors
