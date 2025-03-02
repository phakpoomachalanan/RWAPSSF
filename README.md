สิ่งที่แก้ไปจากของเก่า

    struct Player มีการเพิ่ม
        1. timestamp - ใช้อ้างอิงตอนเรียกขอเงินคืนโดยถ้ารอมานานเกินกว่า timeLimit

    สร้าง map (address => uint) เพื่อให้ user ไม่ต้องนั่งหา id ของตัวเอง

    function
        1. _reset 
            - เพื่อทำการรีเซ็ตค่าต่างๆเมื่อเกมจบรอบหรือมีคนถอนเงินออก โดยมีการกำหนดว่าค่า default ไว้ว่า      
                - player id = 0 - หมายความว่า address นี้ยังไม่ได้ลงทะเบียนในรอบนั้นๆ
                - player choice = 7 - หมายความว่า player ยัวไม่ได้เลือกคำตอบ
        2. viewPlayer
            - เพื่อดูค่าต่างๆของ player address นั้นๆ
            - ดูได้เฉพาะของคนที่เรียก
        3. viewGameStatus
            - ดูค่าต่างๆในเกม เช่น จำนวนผู้เล่น
            - ใครเข้ามาดูก็ได้
        4. addPlayer
            - ดักกรณี player เพิ่มตัวเองสองครั้งและแก้ให้ player id เริ่มที่ 1
        5. input
            - ปรับให้ใช้ในแบบไม่ต้องให้ player ใส่ idx เอง
            - เวลา input ตอนแรกจะไม่ได้เก็บค่า choice แต่เป็น hash ของ choice และ salt
            - ต้องเป็นคนที่ลงทะเบียนไว้แล้วเท่านั้น
        6. revealChoice
            - เป็นการเฉลยคำตอบของตัวเองด้วยการใส่ choice และ salt ที่ใส่ใน input ไปตอนต้นโดยค่านี้จะต้องเท่ากันถึงจะยอมรับคำตอบ
            - สามารถเฉลยได้ครั้งเดียว
            - ต้องเป็นคนที่ลงทะเบียนไว้แล้วเท่านั้น
        7. withdraw
            - เพื่อขอดึงเงินคืนตอนที่ไม่มีคนเข้ามาเล่นด้วยหรือเข้ามาแล้วแต่ไม่เล่น
                - ตอนที่ไม่มีคนเข้ามาเล่นด้วย: คืนให้คนขอคนั้น
                - เข้ามาแล้วแต่ไม่เล่น: คืนเงินเท่าๆกันให้ทั้งสองฝ่าย
                - เข้าเล่นทั้งคู่แต่มีคนเฉลยคำตอบตัวเองแค่คนเดียว: คืนเงินเท่าๆกันให้ทั้งสองฝ่าย
            - ต้องเป็นคนที่ลงทะเบียนไว้แล้วเท่านั้น
            - เวลาต้องผ่านไป 10 นาทีแล้วจากที่คนนั้นเข้าร่วมเล่น
            - กดคนเดียว
        8. _checkWinnerAndPay
            - แก้ไขเงื่อนไขในการชนะ ปรับเพื่อให้รองรับการเล่น RWAPSSF

ตัวอย่างการเล่น มีผู้ชนะ

    1. ผู้เล่นเข้าร่วมครบ 2 คน
![Alt text](./picture/pic00.png?raw=true "ผู้เล่น")
![Alt text](./picture/pic01.png?raw=true "ผู้เล่นเข้าร่วมครบ 2 คน")

    2. ผู้เล่นทั้ง 2 คนใส่ input ทั้งสองคน
![Alt text](./picture/pic02.png?raw=true "ผู้เล่นคนแรกใส่ input")
![Alt text](./picture/pic03.png?raw=true "ผู้เล่นคนที่สองใส่ input")

    3. ผู้เล่นทั้ง 2 คน reveal คำตอบของตน
![Alt text](./picture/pic04.png?raw=true "ผู้เล่นคนแรก reveal คำตอบของตน")
![Alt text](./picture/pic05.png?raw=true "ผู้เล่นคนที่สอง reveal คำตอบของตน")
(player คนหลังดูข้อมูลไม่ได้แล้ว)
![Alt text](./picture/pic06.png?raw=true "player คนหลังดูข้อมูลไม่ได้แล้ว")

    4. ผู้เล่นที่ชนะจะได้เงินไป 2 ether
![Alt text](./picture/pic07.png?raw=true "ผู้เล่นที่ชนะจะได้เงินไป 2 ether")

ตัวอย่างการเล่น เสมอ

    1. ผู้เล่นเข้าร่วมครบ 2 คน
![Alt text](./picture/pic10.png?raw=true "ผู้เล่น")
![Alt text](./picture/pic11.png?raw=true "ผู้เล่นเข้าร่วมครบ 2 คน")

    2. ผู้เล่นทั้ง 2 คนใส่ input ทั้งสองคน
![Alt text](./picture/pic12.png?raw=true "ผู้เล่นคนแรกใส่ input")
![Alt text](./picture/pic13.png?raw=true "ผู้เล่นคนที่สองใส่ input")

    3. ผู้เล่นทั้ง 2 คน reveal คำตอบของตน
![Alt text](./picture/pic14.png?raw=true "ผู้เล่นคนแรก reveal คำตอบของตน")
![Alt text](./picture/pic15.png?raw=true "ผู้เล่นคนที่สอง reveal คำตอบของตน")
(player คนหลังดูข้อมูลไม่ได้แล้ว)
![Alt text](./picture/pic16.png?raw=true "player คนหลังดูข้อมูลไม่ได้แล้ว")

    4. ผู้เล่นได้เงินคืนคนละ 1 ether
![Alt text](./picture/pic17.png?raw=true "ผู้เล่นได้เงินคืนคนละ 1 ether")