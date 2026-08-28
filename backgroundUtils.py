import os


def getBackgrounds() -> dict:
    """
    Returns a dictionary of background names and their corresponding file paths.

    Args:
        - None

    Returns:
        - dict: A dictionary where keys are background names and values are
                the full file paths to the background images.
    """
    currentDirectory = os.path.dirname(os.path.abspath(__file__))
    backgroundsDirectory = os.path.join(currentDirectory, "backgrounds")
    backgrounds = {}

    for filename in os.listdir(backgroundsDirectory):
        backgroundName, _ = os.path.splitext(filename)
        backgrounds[backgroundName] = os.path.join(backgroundsDirectory, filename)

    return backgrounds
