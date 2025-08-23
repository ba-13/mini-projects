from wheel_distance_dynamics import Wheel, DistanceSensor
from bayesian_estimation import Estimator

import numpy as np
import matplotlib.animation as animation
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

Model = Wheel
Sensor = DistanceSensor
N = Model.N  # number of states
STEPS = 50  # number of simulated steps

X_INIT = int(N / 4)  # initial state


def scene():
    global N
    np.random.seed(0)
    wheel = Model(X_INIT)
    observer = Sensor()

    estimator = Estimator()
    estimator.init_exact_prior(X_INIT)
    pdf_history = np.zeros((STEPS, N))
    theta_history = np.zeros(STEPS, dtype=np.int32)
    for step in range(STEPS):
        pdf_history[step, :] = estimator.pdf_x
        # estimator.pdf_state is the distribution of estimated state
        theta_history[step] = wheel.x
        wheel.step()
        state = wheel.state(wheel.x)
        measurement = observer.measure(state)

        estimator.update(measurement)
    return pdf_history, theta_history


theta_values = np.array([Model._get_theta(i, degree=True) for i in range(N)])
pdf_history = scene()

# Run simulation
pdf_history, theta_history = scene()


def animation_2d():
    # Set up the figure
    fig, ax = plt.subplots()
    ax.set_ylim(0, 0.3)  # Assuming probabilities
    ax.set_xticks(np.arange(len(theta_values)))  # Set x-axis ticks
    ax.set_xticklabels(
        [f"{theta:.2f}" if i % 4 else "" for i, theta in enumerate(theta_values)],
        rotation=45,
        ha="right",
    )  # Annotate with theta values

    bar_container = ax.bar(
        np.arange(len(pdf_history[0])), pdf_history[0], color="blue"
    )  # Default color

    current_frame = [0]  # Store in a list to allow modification inside functions

    def update(frame):
        """Update the bar heights and title for the given frame."""
        actual_theta_idx = theta_history[frame]
        actual_theta = Model._get_theta(actual_theta_idx, degree=True)
        for i, (bar, height) in enumerate(zip(bar_container, pdf_history[frame])):
            bar.set_height(height)
            bar.set_color("red" if i == actual_theta_idx else "blue")
        ax.set_title(f"Step {frame} | Theta: {actual_theta:.2f}")
        ax.legend(
            [bar_container[actual_theta_idx]],
            ["Most probable state"],
            loc="upper right",
        )
        plt.draw()

    def on_key(event):
        """Handle key press events to navigate frames."""
        if event.key == "right":  # Move forward
            if current_frame[0] < len(pdf_history) - 1:
                current_frame[0] += 1
                update(current_frame[0])
        elif event.key == "left":  # Move backward
            if current_frame[0] > 0:
                current_frame[0] -= 1
                update(current_frame[0])

    # Connect key press event
    fig.canvas.mpl_connect("key_press_event", on_key)

    # Initial plot
    update(current_frame[0])

    plt.show()


def graph_3d():
    # Generate meshgrid for 3D plotting
    STEPS, N = pdf_history.shape
    X, Y = np.meshgrid(np.arange(N), np.arange(STEPS))

    # Create the 3D plot
    fig = plt.figure(figsize=(10, 6))
    ax = fig.add_subplot(111, projection="3d")

    # Plot the surface
    ax.plot_surface(X, Y, pdf_history, cmap="viridis")

    # Labels
    ax.set_xlabel("State Index")
    ax.set_ylabel("Time Step")
    ax.set_zlabel("Probability")
    ax.set_title("3D Evolution of PDF Over Time")

    ax.plot(theta_history, np.arange(STEPS), np.ones(STEPS) * 0.3, linewidth=3, c="b")

    plt.show(block=False)


graph_3d()
# animation_2d()
