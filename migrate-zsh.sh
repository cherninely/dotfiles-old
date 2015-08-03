#!/bin/bash

function print_message() {
    echo ${ORANGE}${BOLD}
    echo -e "\n ❯ $1"
    echo ${RESET}
}

function ask_question() {
    echo ${GREEN}${BOLD}
    echo "$1[yn] :?"; read $2
    echo ${RESET}
}

#
print_message "Проверить окружение"
if [[ "$(git branch --contains ZSH | grep $(git-get-br))" ]]; then
    print_message "Вы наследуете ветку ZSH, всё ок"
else
    print_message "Переключитесь/смержитесь с веткой ZSH"
    exit 1
fi

#
print_message "Установить ZSH если не установлен..."
which zsh > /dev/null || sudo apt-get install zsh

print_message "Установить необходимые утилиты"
which wget > /dev/null 2>&1 || sudo apt-get install wget
which unzip > /dev/null 2>&1 || sudo apt-get install unzip

# установить или не установить OMZ
ask_question 'Ставим OMZ (oh-my-zsh)' WANT_OMZ

if [[ $WANT_OMZ = y ]]; then

    echo 'Ура, Ставим:'
    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -qO- | zsh; echo Продолжаем миграцию...

    print_message "Установить тему ya-mm..."
    cd ~/.oh-my-zsh/themes && wget https://raw.githubusercontent.com/bem-kit/oh-my-zsh/master/themes/ya-mm.zsh-theme

    print_message "Установить fasd (github.com/clvv/fasd)..."
    if [ $IS_OSX ]; then
        brew install fasd
    else
        wget https://github.com/clvv/fasd/zipball/master -qO- > fasd.zip && unzip fasd.zip
        cd fasd/* && sudo make install
    fi

else
    WANT_OMZ=
fi

ask_question 'Ставим thefuck (github.com/nvbn/thefuck)' WANT_THEFUCK

if [[ $WANT_THEFUCK = y ]]; then
    echo 'Ставим!'
    if [ $IS_OSX ]; then
        brew install thefuck
    else
        sudo apt-get update
        sudo apt-get uninstall python-pip python-dev
        sudo apt-get install python-pip python-dev
        sudo pip install thefuck
    fi
else
    WANT_THEFUCK=
fi

ask_question 'Ставим bem-cat' WANT_BEMCAT

if [[ $WANT_BEMCAT = y ]]; then
    echo 'Ставим!'
    wget -qO- https://github.yandex-team.ru/bem-kit/bem-levels/raw/master/install.sh | sh
else
    WANT_BEMCAT=
fi

mkdir -p ~/.config/git/
touch ~/.config/git/config
git config -f ~/.config/git/config user.email "$(git config user.email)"
git config -f ~/.config/git/config user.name "$(git config user.name)"
mv ~/.gitconfig ~/.gitconfig.bak
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

echo ${ORANGE}${BOLD}
echo 'Внимание: ~/.gitconfig забэкаплен (~/.gitconfig.bak)) и заменён симлинкой на dotfiles'
echo 'Запустите diff ~/.gitconfig.bak ~/.gitconfig чтобы проверить отличия'
echo 'Используйте ~/.config/git/config для ваших настроек git, а так же имени и email'
echo ${RESET}

#
print_message "Заменить .zshrc на симлинк из dotfiles..."

([ -e ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak); ln -s ~/dotfiles/.zshrc ~

print_message "Прежний конфиг сохранён в ~/.zshrc.bak"

#
print_message 'Попытаться переключить шелл'

sudo chsh -s $(which zsh) $(whoami)

echo ${ORANGE}${BOLD}
echo Всё, перезагружайтесь
echo
echo 'Если шелл таки не переключится, то добавьте себя в /etc/passwd и /etc/group (sudo vim ...)'
echo 'Возможно, это костыльно, но другого способа разрешения этой проблемы не найдено (пока)'
echo 'Возможно, более правильным будет указание своего шелла на стиаффе'
echo ${RESET}
