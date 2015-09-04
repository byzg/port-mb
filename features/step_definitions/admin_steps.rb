Пусть(/^есть админ$/) do
  FactoryGirl.create(:admin)
end

Пусть(/^я вхожу в админку$/) do
  steps %Q(
      И я вхожу на страницу "/admin/login"
      И я ввожу "admin@example.com" в поле "Эл. почта"
      И я ввожу "qwer4321" в поле "Пароль"
      И я нажимаю кнопку "Войти"
    )
end