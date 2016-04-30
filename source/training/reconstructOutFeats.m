function y = reconstructOutFeats(featMat,store) 
    for i = 1:size(store,1)
        a = store(i,1);
        b = store(i,2);
        y(:,i) = a + featMat(:,i)*( b - a );
    end