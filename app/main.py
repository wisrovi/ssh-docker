from fastapi import FastAPI
import multiprocessing
import os


def start_sshd():
    os.system("/usr/sbin/sshd -D")
#multiprocessing.Process(target=start_sshd).start()
start_sshd()


app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}
