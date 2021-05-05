task(:travis).clear.enhance(%i[rubocop spec cucumber:pipeline])
