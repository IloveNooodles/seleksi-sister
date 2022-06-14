import hashlib
import hmac
import math
import time
import requests
from requests.structures import CaseInsensitiveDict
import base64

sharedKey = b"seleksister2213520029"
step_in_seconds = 30
calculatedTime = math.floor(time.time() // step_in_seconds)
totpLength = 8
URL = "http://svr.suggoi.fun:42069/submit/a"

# find the HMAC first
hmac_object = hmac.new(sharedKey, calculatedTime.to_bytes(
    length=8, byteorder="big"), hashlib.sha256)
hmac_sha256 = hmac_object.hexdigest()

# 64 byte ambil 4 bits terakhir berarti ambil index 31


def TOTP(hash):
    offset = int(hmac_sha256[-1], 16)
    # convert to binary then int
    binary = int(hmac_sha256[(offset * 2):((offset*2)+8)], 16) & 0x7fffffff
    return str(binary)[-totpLength:]


def sendRequest(totp, NIM, data):
    auth = f"{NIM}:{totp}"
    authB64 = base64.b64encode(auth.encode("ascii"))
    headers = CaseInsensitiveDict()
    headers["Accept"] = "application/json"
    headers["Authorization"] = f"Basic {authB64}"
    headers["Content-Type"] = "application/json"

    r = requests.post(URL, headers=headers, data=data)
    print(r.status_code)
    return r.status_code


def makeData(name, link, message):
    return {
        "fullName": name,
        "link": link,
        "message": message,
    }


def submitAnswer(NIM):
    totp = TOTP(hmac_sha256)
    data = makeData("Muhammad Garebaldhie ER Rahman", "https://github.com/IloveNooodles/seleksi-sister",
                    "TACHIBANA RUI WANGI WANGII")  # isi sendiri
    auth = f"{NIM}:{totp}"
    authB64 = base64.b64encode(auth.encode("ascii"))
    print(auth)
    print(authB64)
    print(data)


submitAnswer("13520029")  # isi sendiri
