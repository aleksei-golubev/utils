# Remove files in list:

for el in $(cat $1); do
	rm -rf $el;
done;
