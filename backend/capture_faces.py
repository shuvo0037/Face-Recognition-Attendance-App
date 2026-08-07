import cv2
import os
import sys

if len(sys.argv)>1:
    student_id=sys.argv[1]
else:
    student_id=input("Student ID: ")

save_path=os.path.join("dataset",student_id)

os.makedirs(save_path,exist_ok=True)

camera=cv2.VideoCapture(0)

detector=cv2.CascadeClassifier(
    cv2.data.haarcascades+
    "haarcascade_frontalface_default.xml"
)

count=0

while True:
    ret,frame=camera.read()

    if not ret:
        break

    gray=cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)

    faces=detector.detectMultiScale(gray,1.3,5)

    for(x,y,w,h) in faces:
        face=gray[y:y+h,x:x+w]

        count+=1

        cv2.imwrite(
            os.path.join(save_path,f"{count}.jpg"),
            face,
        )

        cv2.rectangle(frame,(x,y),(x+w,y+h),(0,255,0),2)

        cv2.putText(
            frame,
            str(count),
            (x,y-10),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.8,
            (0,255,0),
            2,
        )

    cv2.imshow("Face Registration",frame)

    key=cv2.waitKey(1)

    if key==ord("q"):
        break

    if count>=150:
        break

camera.release()
cv2.destroyAllWindows()

print("Dataset Saved Successfully")