dotfiles
========

Конфиги для разработчика интерфейсов.

### Установка

```bash
git clone git://github.yandex-team.ru/search-interfaces/dotfiles ~/dotfiles && ~/dotfiles/install.sh
```

### Для ZSH early adopters

Как перейти на ZSH (опционально с oh-my-zsh)

1. Аккуратно смержиться с веткой ZSH (в любой непонятной ситуации зовите @invntrm)
2. Перезагрузить шелл
3. Выполнить простой [скрипт «миграции»](migrate-zsh.sh): `./migrate-zsh.sh`
4. Не торопитесь сразу возвращать в .zshrc свои плагины и настройки из `.zshrc-bak`

### FAQ

Здесь должен был быть FAQ, но, поскольку вопросы пока никто не задавал, здесь пусто.
Просьба записывать свои вопросы (а также замечания к этому руководству) [здесь](/../../issues/7). Ещё можно написать на почту vorian@yandex-team.ru или на рассылку search-interfaces@yandex-team.ru.

### Основные фичи

#### Bash

Рекомендуется освоить основные шоткаты в bash, такие как `<c-a>`, `<c-e>`, `<c-w>`, `<c-r>` etc (здесь и далее "`<c-a>`" следует читать как "Ctrl+a"). Дополнительно можно почитать [тут](http://en.wikipedia.org/wiki/Bash_(Unix_shell)#Keyboard_shortcuts) или [тут](http://habrahabr.ru/post/99843/).

Точка входа – `.profile`, часть конфигов находится в нём, остальное сгруппировано по функциональности в файлах `.aliases`, `.exports`, `.extra` etc. Эти файлы сорсятся изнутри `.profile`.

#### Git

Для работы с git подключен [файл автодополнений](./git-completion.bash), [пачка алиасов git](./.gitconfig#L33-L59) и [bash](./.aliases#L28-L42).

#### VIM

Не знаю пока, в каком виде писать help по vim.
Если вы в vim новичок, можно посмотреть базовые команды vim [тут](https://beta.wiki.yandex-team.ru/search-interfaces/vim/base/) плюс документацию самого vim: `vimtutor` и `:help`.
У меня предложение следующее: если вы уже пользуетесь vim не менее 3 месяцев и открыли для себя какую-нибудь новую команду/фичу/плагин, которую можете посоветовать остальным, смело пишите об этом в списке ниже (или отправляйте пул-реквест).

Пока здесь будет инфа об основных мапах и плагинах, которые отличают этот конфиг vim от остальных.

##### [NeoBundle](https://github.com/Shougo/neobundle.vim) – менеджер плагинов

##### [Unite](https://github.com/Shougo/unite.vim) – оболочка для работы со списками
Название звучит немного абстрактно, поэтому напишу об основных кейсах использования с этим конфигом.

1. `<Space>b` - Показать список открытых файлов. 
2. `<Space>f` - Поиск файлов по проекту. **NB:** в проектах с bem может сильно тормозить из-за большого количества файлов.  Здесь пригодится [тонкая](https://github.yandex-team.ru/mm-interfaces/sakhalin/blob/dev/.vimrc)  [настройка](https://github.yandex-team.ru/mm-interfaces/sakhalin/blob/dev/.agignore). 
3. `<Space>/`, `<Space>*` - Поиск кода по проекту. 
4. `<Space>m` - Список всех мапов в vim. 

Можно создавать свои собственные списки.

##### [VimShell](https://github.com/Shougo/vimshell.vim) – интерактивная консоль внутри vim

Открывается по `\h` (`<leader>h`)

##### [VimFiler](https://github.com/Shougo/vimfiler.vim) – Продвинутый файловый менеджер (замена netrw и nerdtree)

Открывается/закрывается по `<Bs>`  
Также `\f` (`<leader>f`) открывает vimfiler и находит в нём текущий файл

Про остальные мапы лучше почитать help по мапам (нужно набрать `g?` в буфере с vimfiler) или общий help (`:h vimfiler`). Несколько основных примеров:  
`v` - Превью файла  
`o`, `<CR>` - Открыть файл/папку  
`l`, `<Right>` - Переместиться в папку (или открыть файл)  
`h`, `<Left>` - Переместиться в родительскую папку  

`gf` - Поиск по файлам в текущей папке (использует `Unite file_rec`)  
`gr` - Поиск по коду в текущей папке (использует `Unite grep`)  

Операции с файлами:  
`cc` - скопировать файл/папку  
`dd` - удалить файл/папку  
`mm` - переместить файл/папку  
`r` - переименовать файл/папку  
`N` - новый файл  
`K` - новая папка  

##### [Neosnippet](https://github.com/Shougo/neosnippet.vim) – поддержка сниппетов
Автодополнение и разворачивание сниппетов при наборе кода по нажатию `<Tab>`. Примеры:

Для css
```css
dn ->
    display: none;
poa ->
    position: absolute;
```

Для js
```js
cl ->
    console.log(${1});
f ->
    function(${1}) {
        ${3}
    }${2}
```
Можно использовать дополнительные функции. Например, сниппет `decl` умеет доставать модификатор из имени файла, что удобно в bem-проектах:
```js
// serp-item_layout_tile.js
decl ->
    BEM.DOM.decl({ block: 'serp-item', modName: 'layout', modVal: 'tile' }, {

        onSetMod: {

            js: {
                inited: function() {
                    ${1}
                }
            }

        }

    });
```

Новые сниппеты добавить очень легко правкой файлов в `~/.vim/snippets` (для быстрого открытия есть мап `\vs`). Они подхватываются на лету.

##### [tComment](https://github.com/tomtom/tcomment_vim) – комментирование кода
Использование:

В normal-mode `gc`+motion – закомментировать текст по motion, `gcc` – одну строку. Например, `gcip` закомментирует текущий абзац с текстом.

В visual-mode `gc` закомментирует выделенный текст.
- `gc` в  – закомментировать текущую строк

##### [Surround](https://github.com/tpope/vim-surround) – удобные операции со скобками и кавычками
Лучше почитать документацию на гитхабе. Простые примеры: если код под курсором находится в скобках, `dsb` удалит эти скобки; а `cs"'` поменяет у строки двойные кавычки на одинарные.

##### [Fugitive](https://github.com/tpope/vim-fugitive) – мощный плагин для работы с git
Лучше почитать документацию на гитхабе.

Несколько основных кейсов использования:
- `\g`(`:Gstatus`) откроет в сплите текущий `git status`
- в этом же сплите можно добавить/удалить файлы из stage кнопкой `-`
- нажатие `D` откроет diff-view предыдущей и текущей версий файла под курсором (того же самого можно добиться для текущего файла командой `:Gdiff`)
- `:Gblame` откроет `git blame` в вертикальном сплите. Нажатие `o` или `<Enter>` в этом сплите откроет просмотр коммита под курсором. Также работают мапы `\b` в normal-mode (`git blame` для текущей строки) и в visual-mode (`git blame` для выделенного текста)

#### Tmux

В конфиге для tmux'а:
- цветовая схема
- поддержка мыши

Bash-команды

- `tm` - создать новую сессию tmux на сокете `tm-$USER`
- `tm a` - открыть последнюю из ранее созданных сессий
- `tm-pair username sessionname` - присоединиться к сессии другого пользователя (для парного программирования)

Команды tmux'а

- `<c-b>?` - help (список команд). Закрывается по q
- `<c-b>c` - Открыть новое окно в текущей сессии
- `<c-b>n` - Перейти в следующее окно
- `<c-b>2` - Перейти в окно под номером 2
- `<c-b>%` / `<c-b>"` - Открыть вертикальный ⎅ / горизонтальный сплит ⌸
- `<c-b>o` - Переключиться между сплитами
- `<c-b>$` - Переименовать сессию
- `<c-b>s` - Переключиться между сессиями

#### Ag (ack)

Для поиска кода по файловой системе рекомендуется использовать программы ag или ack. По функциональности они одинаковые, но ag работает значительно быстрее.

#### Bin

В папке `bin` есть несколько полезных для работы скриптов. Например:
* `watch` отслеживает изменения файлов (удобно при отладке),
* `wcnew` быстро создаёт рабочую копию.
* `wclog` выводит логи репорта nonstop (и сюда же выводятся console.log() из *.priv.js, соответственно).
* `wcurl` выводит url текущей рабочей копии.
* `wcname` — название рабочей копии, как глубоку внутри бы вы не находились
* `wcpath` — путь к рабочей копии (предполагается расположение в ~), как глубоку внутри бы вы не находились
* `all` — названный по историческим присинам алиас для условно: `**/*_common.priv.js`

`wcnew` работает, в каком бы месте файловой системы вы не находились,

`wcurl`, `wcname`, `wcpath`, `all` работают на любой глубине в директории рабочей копии 


###### Wcnew

Примеры использования:
```sh
wcnew tmp images3               # Старый формат
wcnew tmp video_touch_phone -m  # Со сборкой (--make)
wcnew tmp images/deskpad -m     # Новый формат
wcnew tmp fiji -m               # Развёртывание и сборка целиком
wcnew wc1 images3/+video3       # Несколько проектов
wcnew tmp web4 --make           # СЕРП (-m = make build)
wcnew wc2 images --branch feature --make # Продолжение работы на новой машинке https://yadi.sk/i/rgw1akC_gjJ8W
```

Опции:
```sh
--branch  -b  Переключиться на git-ветку (выполняется до сборки, см опцию -m)
--make    -m  Собрать после клонирования
--tmux    -t  Открыть tmux с рабочей копией

```

[Про создание рабочих копий (wiki)](https://beta.wiki.yandex-team.ru/search-interfaces/multimedia/workcopy/)

###### All

```sh
all            # Просто открыть в vim собранный priv.js для .project
all 134        # То же самое, но прыгнуть на строчку
all 4560 video # video = video/desktop
all 4560 images/touch-phone	
```
