# TODO - encrypt and decrypt
import random
import json


def gcd(a, b):
    if b == 0:
        return a
    else:
        return gcd(b, a % b)


def is_prime(n):
    """
    Slower but 100% precise
    """
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, int(n**0.5) + 1, 2):
        if n % i == 0:
            return False
    return True


def extended_euclidean_algorithm(a, b):
    # @param ax + by = gcd(a,b)
    """
    Based on the fact that:
     b % a = b - (b // a) * a\\
     gcd(a, b) = gcd(b%a, a)
    """
    if a == 0:
        return b, 0, 1
    gcd, x1, y1 = extended_euclidean_algorithm(b % a, a)
    x = y1 - (b//a)*x1
    y = x1
    return (gcd, x, y)


def mod_multiplicative_inverse(a, n):
    # TODO
    # @param (a, n) such that at = 1 mod(n), t has to be found.
    """
    Can return t, if at = 1 mod(n) exists, which always will cause gcd(a, n) is ensured before.\\
    This is equivalent to finding (at + ns = gcd(a,n)) mod(n)
    """
    gcd, t, s = extended_euclidean_algorithm(a, n)
    if t == None:
        raise ValueError("No Existing Inverse")
    if t < 0:
        t = t + n
    return t


def key_generation(p, q):
    # @params p, q are the large primes to be passed for key generation
    """
    Returns ((public key), (private key))\\
    p, q should not be revealed anywhere.
    """
    if not (is_prime(p) and is_prime(q)):
        raise Exception("One of them aren't primes")
    elif p == q:
        raise Exception("Both are equal!")
    else:
        prod = p * q
        totient = (p - 1) * (q - 1)
        e = random.randrange(2, totient)
        while gcd(e, totient) != 1:
            e = random.randrange(2, totient)
        return ((e, prod), (mod_multiplicative_inverse(e, totient), prod))


def encrypt(plainText, file_name='public_keys.json', block_size=2):
    """
    Encrypts a plaintext (string)
    """

    try:
        with open(file_name, 'r') as f:
            public = json.load(f)
    except FileNotFoundError:
        print('No such file found.')

    encrypted_blocks = []
    ciphertext = -1

    # First converting characters to cipherText of ASCII values
    # example for block-size 3, 'ABf' is converted to 65066102
    if(len(plainText) == 0):
        raise IOError("Plaintext is empty.")

    ciphertext = ord(plainText[0])
    for i in range(1, len(plainText)):
        if (i % block_size == 0):
            encrypted_blocks.append(ciphertext)
            ciphertext = 0

        ciphertext = ciphertext * 1000 + ord(plainText[i])

    # add the last block to the list
    encrypted_blocks.append(ciphertext)

    for i in range(len(encrypted_blocks)):
        print(public["n"], encrypted_blocks[i],
              ((encrypted_blocks[i] ** public["e"]) % public["n"]))
        encrypted_blocks[i] = str(
            (encrypted_blocks[i]**public["e"]) % public["n"])

    # create a string from the numbers
    encrypted_message = " ".join(encrypted_blocks)

    return encrypted_message


def decrypt(cipherText, block_size=2):
    """
    Decrypts a string of numbers
    """

    with open('private_key.json', 'r') as f:
        private = json.load(f)

    # turns the string into a list of ints
    cipherText = cipherText.split(' ')

    message = ""

    for i in range(len(cipherText)):
        # Converting back to blocks
        cipherText[i] = (int(cipherText[i])**private["d"]) % private["n"]

        tmp = ""
        for c in range(block_size):
            tmp = chr(cipherText[i] % 1000) + tmp
            cipherText[i] //= 1000
        message += tmp

    return message


if __name__ == '__main__':
    print("RSA implementation with no third-party libraries")
    p = int(input("Enter a prime: "))
    q = int(input("Enter another prime: "))

    public, private = key_generation(p, q)
    print(f"Your public key is: {public}")
    print(f"Your private key is saved in `./private.json`")
    with open('public_key.json', 'w') as f:
        e, n = public
        public_json = json.dumps({"e": e, "n": n}, indent=4)
        f.write(public_json)
    with open('private_key.json', 'w') as f:
        d, n = private
        private_json = json.dumps({"d": d, "n": n}, indent=4)
        f.write(private_json)

    # Taking up plaintext
    choice = input(
        "Save your plaintext as `./plaintext.txt` or input here (1 or 2): ")
    if choice == '1':
        try:
            with open('plaintext.txt', 'r') as f:
                plainText = f.read()
        except:
            print("File problems.")
            choice = '2'
    if choice == '2':
        plainText = input("Enter Message to be encrypted: ")

    # Encrypting plaintext
    blockSize = 2
    cipherText = encrypt(plainText, 'public_key.json', blockSize)
    with open('ciphertext.txt', 'w') as f:
        f.write(cipherText)

    print(f"Your encrypted message is saved in `./ciphertext.txt`\n")

    print("Your original message was: ")

    print(decrypt(cipherText, blockSize))
