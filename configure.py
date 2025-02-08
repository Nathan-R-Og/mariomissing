
import os
import shutil
import tools.yamlSplit


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Configure the project")

    args = parser.parse_args()

    if os.path.exists("split/"):
        shutil.rmtree("split/")

    tools.yamlSplit.doSplit("split")
