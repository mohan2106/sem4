CC = g++
INCLUDES = `mysql_config --include`
LIBS = `mysql_config --libs`
-DBBOOST_ROOT=/usr/include/boost

all: credit tt_voilation

180101042_credit.o: 180101042_credit.cpp 
	$(CC) -c $(INCLUDES) 180101042_credit.cpp

180101042_tt_voilation.o: 180101042_tt_voilation.cpp
	$(CC) -c $(INCLUDES) 180101042_tt_voilation.cpp

credit: 180101042_credit.o 
	$(CC) -o credit 180101042_credit.o $(LIBS)

tt_voilation: 180101042_tt_voilation.o
	$(CC) -o tt_voilation 180101042_tt_voilation.o $(LIBS)

.PHONY : clean
clean:
	rm -f credit 180101042_credit.o 180101042_tt_voilation.o tt_voilation