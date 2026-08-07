from fastapi import FastAPI,UploadFile,File
import cv2
import numpy as np
import os

app=FastAPI()

recognizer=cv2.face.LBPHFaceRecognizer_create()
recognizer.read("trainer.yml")

faceCascade=cv2.CascadeClassifier(
    cv2.data.haarcascades+
    "haarcascade_frontalface_default.xml"
)

@app.get("/")
def home():
    return {"message":"Attendance Backend Running"}

@app.get("/health")
def health():
    return {"status":"OK"}

@app.post("/verify")
async def verify(file:UploadFile=File(...)):
    data=await file.read()

    image=np.frombuffer(data,np.uint8)

    frame=cv2.imdecode(image,cv2.IMREAD_COLOR)

    gray=cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)

    faces=faceCascade.detectMultiScale(gray,1.2,5)

    if len(faces)==0:
        return {
            "success":False,
            "message":"No face detected"
        }

    x,y,w,h=faces[0]

    id_,confidence=recognizer.predict(
        gray[y:y+h,x:x+w]
    )

    if confidence<60:
        return {
            "success":True,
            "studentId":str(id_),
            "confidence":confidence
        }

    return {
        "success":False,
        "message":"Unknown Face"
    }