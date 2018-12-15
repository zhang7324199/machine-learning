for i = 1:length(my_ratings)
    if my_ratings(i) > 0 
        fprintf('%d %d %s\n', my_predictions(i),my_ratings(i), movieList{i});
    end
end

for i = 1:length(my_ratings)
    if my_predictions(i) > 4.9 
        fprintf('----->%d %d %d %s\n',i, my_predictions(i),my_ratings(i), movieList{i});
    end
end