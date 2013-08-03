#/bin/sh

echo "vim installation and config started"
MSG=""
VERBOSE=true
SUCCESS=" executed successfully"
FAIL=" problem in exeution"

function clean_up {
	rm -f ~/.vimrc
	rm -f ~/.gvimrc 
	rm -rf ~/vim 
	rm -rf ~/.vim
	sudo apt-get install curl
	sudo apt-get build-dep vim
}
function check_success {
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
function install_vim {

	MSG="pulled vim source successfully" 
	git clone https://github.com/b4winckler/vim.git vim
	git pull
	cd vim/src
	check_success
	MSG="installing vim"
	sudo make  
	sudo make install
	check_success
	#Create dirs .vim,autoload,bundle and link .vimrc,.gvimrc to vimrc and gvimrc
	MSG="making dirs"
	mkdir -p ~/.vim && cd ~/.vim
	touch vimrc && touch gvimrc && mkdir bundle && mkdir autoload 
	ln -s ~/.vim/vimrc ~/.vimrc && ln -s ~/.vim/gvimrc ~/.gvimrc

}



function vim_plugin_update {

	MSG="pathogen installtion"
	#get the pathogen
	curl -Sso ~/.vim/autoload/pathogen.vim \
	https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
	
	MSG="ctrlp installation"
	#ctrlp plugin to search files
	#TODO check file navigation
	cd ~/.vim && git clone https://github.com/kien/ctrlp.vim.git bundle/ctrlp.vim
	
	
	
	#Set IDE for C/C++
	#nerdtree plugin
	MSG="NERD installation"
	cd ~/.vim/bundle && git clone https://github.com/scrooloose/nerdtree.git

	#Tlist to open and close the definition
	
	#Set IDE for WEB ---> JS,HTML
	#configure vimrc

}

function vimrc_update {
	MSG="vimrc update"
	printf "\
	\n\"NOTE : alias for ctrl = c,ctrl,C alias for enter = cr\
	\ncall pathogen#incubate() \ncall pathogen#helptags() \
	\n:set number \n:set hlsearch  \
	\n:set history=800 \
	\n:set ruler \
	\n:set undolevels=1000\
	\n\"syntax highlight
	\n:syn on\
	\n\":nmap <c-d> dd 
	\n\":imap <c-d> <esc>ddi \
	\n\"Replace esc support with jk \
	\n\"get rid of of esc
	\n:inoremap jk <esc>\
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
	\n\"resize current buffer by +/- 5\ 
	\n\"Fast window resizing with +/- keys (horizontal); > and < keys (vertical)\
	\nif bufwinnr(1) \
	\nmap + <C-W>+\
	\nmap - <C-W>-\
	\nmap < <c-w><\
	\nmap > <c-w>>\
	\nendif \
	\n\"Allow fast switching between window\
	\n:map <C-H> <C-W>h \
	\n:map <C-L> <C-W>l \
	\n\"Redo use <ctrl-r>\
	" &>~/.vim/vimrc
	
	check_success
	#set filetype

}

clean_up
install_vim 
vimrc_update

exit 0
