% this script extracts Chroma features
disp('extracting chroma features...')

% extract train and test Chroma features
firstGenreTestChroma = extract_from_path_chroma([pwd,'\data\first_genre\test\'], ...
    ext,WL,SL);
firstGenreTrainChroma = extract_from_path_chroma([pwd,'\data\first_genre\train\'], ...
    ext,WL,SL);
secondGenreTestChroma = extract_from_path_chroma([pwd,'\data\second_genre\test\'], ...
    ext,WL,SL);
secondGenreTrainChroma = extract_from_path_chroma([pwd,'\data\second_genre\train\'], ...
    ext,WL,SL);
thirdGenreTestChroma = extract_from_path_chroma([pwd,'\data\third_genre\test\'], ...
    ext,WL,SL);
thirdGenreTrainChroma = extract_from_path_chroma([pwd,'\data\third_genre\train\'], ...
    ext,WL,SL);

% extracting Chroma features for noisy test files
disp('extracting chroma features from noisy test files...')
firstGenreNoisyTestChroma = extract_from_path_chroma([pwd,'\data\first_genre\test\noisy\'], ...
    ext,WL,SL);
secondGenreNoisyTestChroma = extract_from_path_chroma([pwd,'\data\second_genre\test\noisy\'], ...
    ext,WL,SL);
thirdGenreNoisyTestChroma = extract_from_path_chroma([pwd,'\data\third_genre\test\noisy\'], ...
    ext,WL,SL);

% labels for test, noisy test and train features
labelFirstGenreTestChroma = ones(length(firstGenreTestChroma),1);
labelSecondGenreTestChroma = repmat(2,length(secondGenreTestChroma),1);
labelThirdGenreTestChroma = repmat(3,length(thirdGenreTestChroma),1);
allTestChroma = [firstGenreTestChroma secondGenreTestChroma thirdGenreTestChroma];
ground_truth_chroma = [labelFirstGenreTestChroma; labelSecondGenreTestChroma; labelThirdGenreTestChroma];

labelFirstGenreNoisyTestChroma = ones(length(firstGenreNoisyTestChroma),1);
labelSecondGenreNoisyTestChroma = repmat(2,length(secondGenreNoisyTestChroma),1);
labelThirdGenreNoisyTestChroma = repmat(3,length(thirdGenreNoisyTestChroma),1);
allNoisyTestChroma = [firstGenreNoisyTestChroma secondGenreNoisyTestChroma thirdGenreNoisyTestChroma];
ground_truth_noisy_chroma = [labelFirstGenreNoisyTestChroma;
    labelSecondGenreNoisyTestChroma; labelThirdGenreNoisyTestChroma];

labelFirstGenreTrainChroma = ones(length(firstGenreTrainChroma),1);
labelSecondGenreTrainChroma = repmat(2,length(secondGenreTrainChroma),1);
labelThirdGenreTrainChroma = repmat(3,length(thirdGenreTrainChroma),1);
allTrainChroma = [firstGenreTrainChroma secondGenreTrainChroma thirdGenreTrainChroma];
allLabelsChroma = [labelFirstGenreTrainChroma; labelSecondGenreTrainChroma; labelThirdGenreTrainChroma];

% normalization
disp('normalization...')
allTrainChroma = allTrainChroma';
mn = mean(allTrainChroma);
st = std(allTrainChroma);
allTrainChroma =  (allTrainChroma - repmat(mn,size(allTrainChroma,1),1))./repmat(st,size(allTrainChroma,1),1);

allTestChroma = allTestChroma';
mn = mean(allTestChroma);
st = std(allTestChroma);
allTestChroma =  (allTestChroma - repmat(mn,size(allTestChroma,1),1))./repmat(st,size(allTestChroma,1),1);

allNoisyTestChroma = allNoisyTestChroma';
mn = mean(allNoisyTestChroma);
st = std(allNoisyTestChroma);
allNoisyTestChroma =  (allNoisyTestChroma - repmat(mn,size(allNoisyTestChroma,1),1))./repmat(st,size(allNoisyTestChroma,1),1);

test = {allTestChroma, allNoisyTestChroma};
test_labels = {ground_truth_chroma, ground_truth_noisy_chroma};
knn_description = {'kNN-based genre classification(Chroma)';
    'kNN-based genre classification(Chroma) adding noise to test set'};
dt_description = {'DT-based genre classification(Chroma)';
    'DT-based genre classification(Chroma) adding noise to test set'};
knn_disp_description = {'training kNN (Chroma)...';
    'training kNN (Noisy Chroma)...'};
dt_disp_description = {'training DT (Chroma)...';
    'training DT (Noisy Chroma)...'};

figure

for j = 1:2
    disp(knn_disp_description{j})
    k=[1 10 20 100 200];
    rate = [];
    for kk=1:length(k)
        % train the kNN
        Mdl = fitcknn(allTrainChroma,allLabelsChroma','NumNeighbors',k(kk));

        % test the kNN
        predicted_label_chroma = predict(Mdl,test{j});

        % measure the performance
        correct = 0;
        for i=1:length(predicted_label_chroma)
            if predicted_label_chroma(i)==test_labels{j}(i)
                correct=correct+1;
            end
        end
        %disp('recognition rate:')
        rate(kk) = (correct/length(predicted_label_chroma))*100;
    end
    [a,b]=max(rate);
    disp('----------results----------------')
    disp(['the maximum recognition rate is ',mat2str(a)])
    disp(['and it is acheived with ',mat2str(k(b)),' nearest neighbors'])

    % train and test the kNN using the best k value
    knn_Mdl_chroma = fitcknn(allTrainChroma,allLabelsChroma','NumNeighbors',(k(b)));
    predicted_label_chroma = predict(knn_Mdl_chroma,test{j});

    % plotting
    subplot(2,2,2*j-1)
    Cknn_chroma = confusionmat(test_labels{j}, predicted_label_chroma)
    cmknn_chroma = confusionchart(Cknn_chroma, {firstGenre  secondGenre  thirdGenre}, ...
        'Title', knn_description{j}, 'RowSummary', 'row-normalized');

    disp(dt_disp_description{j})
    % train the DT
    tree_chroma = fitctree(allTrainChroma,allLabelsChroma);
    % test the DT
    predicted_label_dt_chroma = predict(tree_chroma,test{j});

    % plotting
    subplot(2,2,2*j)
    Ctree_chroma = confusionmat(test_labels{j}, predicted_label_dt_chroma)
    cmtree_chroma = confusionchart(Ctree_chroma, {firstGenre  secondGenre  thirdGenre}, ...
        'Title', dt_description{j}, 'RowSummary', 'row-normalized');
end