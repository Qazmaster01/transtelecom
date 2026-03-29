ТЕХНИЧЕСКОЕ ЗАДАНИЕ на позицию Middle Data Engineer
Мы должны установить проект из гитхаба - git clone https://github.com/Qazmaster01/transtelecom.git
После клона мы должны установить необходимые библиотеки для запуска проекта. Эти библиотеки находится в файле requirements.txt по команде установливаем 
по этому коду pip install -r requirements.txt
После установки мы должны запустить докер контейнер - docker-compose up -d --build
После запуска (примерно через минуту) смотрим статус - docker ps

ВАЖНО!!! При установках и запусках докера и т.д путь должен совпадать. Например для запуска команды pip install -r requirements.txt 
путь должен быть в \transtelecom(в моет случае) тогда вы можете устанавливать, если установить в другом месте будет ошибка.

Если докер не упал, мы можем зайти в этот хост - http://localhost:8080/home
Указываем admin - admin
Заходим в даг retail_pipeline и запускаем 
Конфы от БД: 
    host - localhost
    port - 5433
    user - postgres
    bd - krisha
    password - asdnmk
