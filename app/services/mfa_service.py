import os
import base64
import io

import pyotp
import qrcode
from cryptography.fernet import Fernet

from config import FERNET_KEY

def _fernet() -> Fernet:
    return Fernet(FERNET_KEY)


def gen_secret() -> bytes:
    return pyotp.random_base32().encode()


def encrypt(secret: bytes) -> bytes:
    return _fernet().encrypt(secret)


def decrypt(token: bytes) -> bytes:
    return _fernet().decrypt(token)


def provisioning_uri(username: str, secret: bytes) -> str:
    totp = pyotp.TOTP(secret.decode(), digits=6, interval=30)
    return totp.provisioning_uri(name=username, issuer_name="FinanceTracker")


def qr_png_base64(uri: str) -> str:
    img = qrcode.make(uri)
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    return base64.b64encode(buf.getvalue()).decode()


def verify(code: str, secret: bytes) -> bool:
    totp = pyotp.TOTP(secret.decode(), digits=6, interval=30)
    return totp.verify(code)
