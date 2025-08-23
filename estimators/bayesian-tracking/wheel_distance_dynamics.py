import numpy as np


class Wheel:
    N = 100  # discrete steps on wheel
    R = 0.5  # process bernoulli parameter

    def __init__(self, x=0):
        """
        x is enumerated state
        """
        self.x = x

    @staticmethod
    def process_noise_sample() -> int:
        val = np.random.random()
        if val > Wheel.R:
            return 1
        else:
            return -1

    @staticmethod
    def dynamics(x: int, v: int) -> int:
        return (x + v) % Wheel.N

    def step(self):
        self.x = self.dynamics(self.x, Wheel.process_noise_sample())
        return self.x

    @staticmethod
    def _get_theta(x: int, degree=False):
        if degree:
            return 360 * x / Wheel.N
        return 2 * np.pi * x / Wheel.N

    @staticmethod
    def state(x: int) -> tuple[float, float]:
        theta = Wheel._get_theta(x)
        return np.cos(theta), np.sin(theta)


class DistanceSensor:
    L = 2
    E = 0.5

    @staticmethod
    def measurement_noise_sample():
        return np.random.uniform(-DistanceSensor.E, DistanceSensor.E)

    @staticmethod
    def actual_distance(state: tuple[float, float]) -> float:
        return np.sqrt((DistanceSensor.L - state[0]) ** 2 + (state[1]) ** 2)

    @staticmethod
    def measure(state: tuple[float, float]):
        return (
            DistanceSensor.actual_distance(state)
            + DistanceSensor.measurement_noise_sample()
        )
