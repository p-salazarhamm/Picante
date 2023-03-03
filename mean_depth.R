files = list.files('.')

for (f in files) {
	if (!endsWith(f, '.depth') || file.size(f) == 0) {
		    next
}
	depths = read.table(f, sep = '\t', header = F)
	cat(paste(f, mean(depths[,3]), sep = '\t'), '\n')
}
