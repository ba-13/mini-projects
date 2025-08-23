import numpy as np

from wheel_distance_dynamics import Wheel, DistanceSensor


class Estimator:

    def __init__(self):
        self.num_states = Wheel.N
        self.pdf_x = self.init_prior()

    def init_prior(self):
        return np.ones(self.num_states) / self.num_states

    def init_exact_prior(self, state: int):
        self.pdf_x = np.zeros(self.num_states)
        self.pdf_x[state] = 1

    # you have to characterise the process noise and the dynamics
    # to get the dynamics model.
    # because the number of states are finite, you can do a tabular version
    # where you store how each state can map to another with what probability
    # but we do this analytically
    @staticmethod
    def pdf_dynamics_model(x_next: int, x_curr: int):
        R_est = Wheel.R
        pred_state = Wheel.dynamics(x_curr, 1)
        if pred_state == x_next:
            return R_est
        pred_state = Wheel.dynamics(x_curr, -1)
        if pred_state == x_next:
            return 1 - R_est
        return 0

    # you have to characterise the measurement noise and the measurement
    # to get the measurement model
    @staticmethod
    def pdf_measurement_model(measurement, x: int):
        E_est = DistanceSensor.E
        # Assume L is known as exactly borrowed from the original class
        state = Wheel.state(x)
        deviation = np.abs(measurement - DistanceSensor.actual_distance(state))
        if deviation < E_est:
            return 1 / (2 * E_est)
        return 0

    @staticmethod
    def x_to_idx(x):
        return x

    @staticmethod
    def idx_to_x(idx):
        return idx

    # accepts the pdf of the state
    @staticmethod
    def _update(pdf_x: np.ndarray, measurement: float):
        num_states = pdf_x.size

        priors = np.zeros(num_states)
        for i in range(num_states):
            x_curr = Estimator.idx_to_x(i)
            priors[i] = 0
            for j in range(num_states):
                x_prev = Estimator.idx_to_x(j)
                priors[i] += Estimator.pdf_dynamics_model(x_curr, x_prev) * pdf_x[j]

        posteriors = np.zeros(num_states)
        for i in range(num_states):
            x_curr = Estimator.idx_to_x(i)
            posteriors[i] = (
                Estimator.pdf_measurement_model(measurement, x_curr) * priors[i]
            )
        posteriors /= np.sum(posteriors)  # normalize
        del priors
        return posteriors

    def update(self, measurement: float):
        self.pdf_x = self._update(self.pdf_x, measurement)
        return self.pdf_x
