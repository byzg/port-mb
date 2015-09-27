#coding: utf-8
PAGES={
    'Главная' => '/',
    'Админ.фото' => '/admin/photos',
    'Админ.альбомы' => '/admin/albums'
}

Пусть(/^я вхожу на страницу "(.*?)"$/) do |page|
  visit (PAGES[page] || page)
end

Пусть(/^я вижу "(.*?)"$/) do |text|
  expect(page).to have_content text
end

When /^я ввожу "(.*?)" в поле "(.*?)"$/ do |value, field_id|
  fill_in field_id, with: value
end

When /^я нажимаю кнопку "(.*?)"$/ do |button_text|
  click_button button_text
end

Пусть(/^я нажимаю(?: первую)? ссылку с текстом "(.*?)"$/) do |link_text|
  page.all('a', text: link_text, visible: true).first.click
end

When /^я должен быть на странице "(.*?)"$/ do |page_name|
  page = PAGES[page_name] || page_name
  expect(current_path).to match(/^#{page}/)
end

Пусть(/^я жду (\d+) секунд.*$/) do |seconds|
  sleep seconds.to_i
end

Пусть(/^я нажимаю на селектор "(.*?)"$/) do |selector|
  find(selector).click
end

When /^я не вижу "(.*?)"$/ do |label|
  expect(page.has_no_content?(label)).to be true
end

И(/^я хочу увидеть скриншот$/) do
  Capybara::Screenshot.screenshot_and_open_image
end