# Задание к уроку "Исключения"
- Реализовать проверку (валидацию) данных для всех классов. Проверять основные атрибуты (название, номер, тип и т.п.) на наличие, длину и т.п. (в зависимости от атрибута):
    - Валидация должна вызываться при создании объекта, если объект невалидный, то должно выбрасываться исключение
    - Должен быть метод valid? который возвращает true, если объект валидный и false - в противном случае.

- Релизовать проверку на формат номера поезда. Допустимый формат: три буквы или цифры в любом порядке, необязательный дефис (может быть, а может нет) и еще 2 буквы или цифры после дефиса.
- Убрать из классов все puts (кроме методов, которые и должны что-то выводить на экран), методы просто возвращают значения. (Начинаем бороться за чистоту кода).
- Релизовать простой текстовый интерфейс для создания поездов (если у вас уже реализован интерфейс, то дополнить его):

    - Программа запрашивает у пользователя данные для создания поезда (номер и другие необходимые атрибуты)
    - Если атрибуты валидные, то выводим информацию о том, что создан такой-то поезд
    - Если введенные данные невалидные, то программа должна вывести сообщение о возникших ошибках и заново запросить данные у пользователя. Реализовать это через механизм обработки исключений
