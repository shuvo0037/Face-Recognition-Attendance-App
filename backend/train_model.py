import cv2
import os
import numpy as np

dataset = "dataset"

recognizer = cv2.face.LBPHFaceRecognizer_create()

faces = []
labels = []

label_map = {}
current_label = 0

detector = cv2.CascadeClassifier(
    cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
)

for person in os.listdir(dataset):

    person_path = os.path.join(dataset, person)

    if not os.path.isdir(person_path):
        continue

    label_map[current_label] = person

    for image_name in os.listdir(person_path):

        image_path = os.path.join(person_path, image_name)

        img = cv2.imread(image_path)

        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        detected = detector.detectMultiScale(gray)

        for (x,y,w,h) in detected:

            faces.append(gray[y:y+h,x:x+w])
            labels.append(current_label)

    current_label += 1

recognizer.train(faces, np.array(labels))

recognizer.save("trainer.yml")

with open("labels.txt","w") as f:

    for key,value in label_map.items():

        f.write(f"{key}:{value}\n")

print("Training Completed")