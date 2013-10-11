#/bin/sh
echo "vim installation and config started"
VERBOSE=true
SUCCESS=" executed successfully"
FAIL=" problem in exeution"
VIM_URL="https://github.com/b4winckler/vim.git"
PATHOGEN="https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
CTRLP="https://github.com/kien/ctrlp.vim.git"
NERD_TREE="https://github.com/scrooloose/nerdtree.git"
INSTALLERS=(curl)
VIM_RC="~/.vim/vimrc"

clean_up() {
	rm -f ~/.vimrc
	rm -f ~/.gvimrc 
	rm -rf ~/vim 
	rm -rf ~/.vim
	sudo apt-get install curl
	sudo apt-get build-dep vim
}
check_success() {
	if [ ${?} -eq 0 ] 
	then
		OP=$MSG$SUCCESS
		$VERBOSE && echo $OP
	else
		OP=$MSG$FAIL
		#return 0
		$VERBOSE && echo $OP
	fi
}
#Install vim and curl
install_vim() {
	MSG="pulled vim source successfully" 
	git_clone_task=`git clone ${VIM_URL} vim`
	git_update_task=`git pull`
	change_dir_task=`cd vim/src`
	check_success
	MSG="installing vim"
	sudo make  
	sudo make install
	check_success
	#Create dirs .vim,autoload,bundle and link .vimrc,.gvimrc to vimrc and gvimrc
	MSG="making dirs"
	mkdir -p ~/.vim && cd ~/.vim
	create_vim_config_task=`touch vimrc && touch gvimrc && mkdir bundle && mkdir autoload`
	create_sl_taks=`ln -s ~/.vim/vimrc ~/.vimrc && ln -s ~/.vim/gvimrc ~/.gvimrc`
}

vim_plugin_update() {
	MSG="pathogen installtion"
	#get the pathogen
	curl -Sso ~/.vim/autoload/pathogen.vim ${PATHOGEN}
	MSG="ctrlp installation"
	#ctrlp plugin to search files
	#TODO check file navigation
	cd ~/.vim && git clone ${CTRLP} bundle/ctrlp.vim
	#nerdtree plugin
	MSG="NERD installation"
	cd ~/.vim/bundle && git clone ${NERD_TREE}
	#Tlist to open and close the definition
}
vimrc_update_global() {
	MSG="Updating global"
	echo -e "\ncall pathogen#incubate() \ncall pathogen#helptags()" >> ${VIM_RC}
	echo -e "\n:set number \n:set hlsearch\n:set history=800\n:set ruler" >> ${VIM_RC}
	echo -e "\n:set backspace=2\n:set tabstop=8\n:set expandtab" >>${VIM_RC}
	echo -e "\n:set shiftwidth=4\n:set softtabstop=4" >>${VIM_RC}
	echo -e "\n\":nmap <c-d> dd \n:imap <c-d> <esc>ddi" >>${VIM_RC}
	echo -e "\n\"Replace esc support with jk \n:inoremap jk <esc>" >>${VIM_RC}
	echo -e "\n\"resize current buffer by +/- 5" >> ${VIM_RC}
	echo -e "\n\"Fast window resizing with +/- keys (horizontal); > and < keys (vertical)">> ${VIM_RC}
	echo -e "\nif bufwinnr(1)">> ${VIM_RC}
	echo -e "\nmap + <C-W>+">> ${VIM_RC}
	echo -e "\nmap - <C-W>-">> ${VIM_RC}
	echo -e "\nmap < <c-w><">> ${VIM_RC}
	echo -e "\nmap > <c-w>>">> ${VIM_RC}
	echo -e "\nendif \">> ${VIM_RC}
	echo -e "\n\"Allow fast switching between window\">> ${VIM_RC}
	echo -e "\n:map <C-H> <C-W>h">>${VIM_RC}
	echo -e "\n:map <C-L> <C-W>l">>${VIM_RC}
	echo -e "\n\"Redo use <ctrl-r>">>${VIM_RC}
	echo -e "\nautocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class" >> ${VIM_RC}
}
vimrc_update() {
	printf "\
	\n\"NOTE : alias for ctrl = c,ctrl,C alias for enter = cr\
	\n\"File Naviagation ctrlp plugin \
	\n:set runtimepath^=~/.vim/bundle/ctrlp.vim \
	\n:set wildignore+=*.so,*.swp,*.zip,*.pyc,*.class\
	\nlet g:ctrlp_show_hidden = 1\
	\nlet g:ctrlp_max_height = 30\
	\nset omnifunc=syntaxcomplete#Complete \
	\nfiletype indent on \
	\n\"tab complete \
	\n\"http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim\
	\nfunction! OmniPopup(action)\
	\nif pumvisible()\
	\n if a:action == 'j'\
	\n      return \"\<C-N>\"\
	\n      elseif a:action == 'k'\
	\n      return \"\<C-P>\"\
	\n      endif\
	\n    endif\
	\n return a:action\
	\nendfunction\
	\ninoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>\
	\ninoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>\
	\n\"shortcut to open NERDTREE\
	\nmap <C-d> :NERDTreeToggle<CR>\
	\n\"syntax on for the respective files\
	" &>~/.vim/vimrc
	check_success
	#set filetype
}

clean_up
install_vim 
vimrc_update_global
vimrc_update

exit 0
