function [cat] = predict_net(ai, ci, col, dia)
    
load trained_net;

testing = zeros(4, 463);
testing(1,1) = ai;
testing(2,1) = ci;
testing(3,1) = col;
testing(4,1) = dia;

test_output = trained_net(testing);

temp = test_output(:,1).';

[max_val, ind_max] = max(temp);

switch (ind_max)
    case 1
        cat = 'Malignant - Melanoma';
    case 2
        cat = 'Malignant - Basal Cell Carcinoma';
    case 3
        cat = 'Malignant - Squamous Cell Carcinoma';
    case 4
        cat = 'Benign - Melanocytic Nevi';
    case 5
        cat = 'Benign - Seborrheic Keratoses';
    case 6
        cat = 'Benign - Acrochordon';
end
end