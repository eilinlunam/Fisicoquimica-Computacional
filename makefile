#####################################################################
#VARIABLES
#####################################################################
PACKDIR=.pack/
include $(PACKDIR)/packrc

CPP=g++
CXXFLAGS=-I. -std=c++11 
LXXFLAGS=-lm 

MSG="Commit"

#####################################################################
#GIT RULES
#####################################################################
commit:
	@echo "Commiting..."
	@-git commit -am "$(MSG)"
	@-git push origin $(BRANCH)

stash:
	@echo "Stashing changes..."
	@-git stash
	@-git pull
	@-git stash pop
	@-make commit

pull:
	@echo "Pulling new files..."
	@-git pull origin $(BRANCH)

pullall:
	@echo "Resetting and pulling new files..."
	@-git reset --hard HEAD
	@-git pull origin $(BRANCH)

branch:
	@echo "We are in branch '$(BRANCH)'"

status:
	@echo "Git Status..."
	@-git status

####################################################################
#COMPILATION RULES
#####################################################################
all:
	bash compile.sh

#=========================
#C and C++ compilation
#=========================
%.out:%.o 
	$(CPP) $^ $(LXXFLAGS) -o $@

%.o:%.cpp 
	$(CPP) -c $(CXXFLAGS) $^ -o $@

#####################################################################
#BASIC RULES
#####################################################################
deps:
	@echo "Checking dependencies for $(SYSTEM)..."
	@bash $(PACKDIR)/deps.sh $(PACKDIR)/deps_pack_$(SYSTEM).conf 

clean:cleancrap cleanout cleanrepo

#=========================
#Clean
#=========================
cleancrap:
	@echo "Cleaning crap..."
	@-find . -name "*~" -delete
	@-find . -name "#*#" -delete
	@-find . -name "#*" -delete
	@-find . -name ".#*" -delete
	@-find . -name ".#*#" -delete
	@-find . -name ".DS_Store" -delete
	@-find . -name ".Icon*" -delete

cleanout:
	@echo "Cleaning all compiled objects..."
	@-find . -name "*.o" -delete
	@-find . -name "*.opp" -delete
	@-find . -name "*.gcno" -delete
	@-find . -name "*.gcda" -delete
	@-find . -name "*.gcov" -delete
	@-find . -name "*.info" -delete
	@-find . -name "*.out" -delete
	@-find . -name "*.tout" -delete
	@-find . -name "*.pyc" -delete
	@-find . -name '__pycache__' -type d | xargs rm -fr

pack:
	@echo "Packing data..."
	@bash $(PACKDIR)/pack.sh

unpack:
	@echo "Unpacking data..."
	@bash $(PACKDIR)/pack.sh unpack

#####################################################################
#EXTERNAL RULES
#####################################################################
#=========================
#Repo Rules
#=========================
include util/repo/repo.in
