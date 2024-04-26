Maak een virutele omgeving voor het project om alle packages erin te kunnen downloaden en het project te kunnen opstarten door deze 2 commands : 
py -m venv myworld
myworld\Scripts\activate.bat

dan alle benodigde packages downloaden:
pip install fastapi
pip install uvicorn
pip install pymysql
pip install sqlalchemy
pip install "python-jose[cryptography]"
pip install passlib[bcrypt]       
pip install python-multipart 


Om De api op te starten moet u in de API folder gaan en deze command uitvoeren:
uvicorn index:app --reload
