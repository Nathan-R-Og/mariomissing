from hashlib import md5

rebuilt_rom = "missing_rebuilt.sfc"
hash = "2a2152976e503eaacd9815f44c262d73"

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Configure the project")

    args = parser.parse_args()

    if hash != md5(open(rebuilt_rom, "rb").read()).hexdigest():
        raise Exception("Hashes do not match")
    else:
        print("OK")
