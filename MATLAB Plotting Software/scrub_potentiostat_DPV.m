function [average,st_dev] = scrub_potentiostat_DPV(data)
    [n,d]=size(data);

    average = [];
    st_dev = [];
    for i = 1:n
        IV_data = [];
        count = 0;
        for j = 1:d
            %fprintf('i=%d,j=%d\n',i,j)
            if ~cellfun(@isempty,data(i,j))
                data_array = table2array(data{i,j});
                a=data_array(:,1)';
                b=data_array(:,2)';
                full_data_matrix_one = [a;b];

                if count==0
                    IV_data = full_data_matrix_one;
                else
                    IV_data = cat(3,IV_data,full_data_matrix_one);
                end
                count = count+1;
            end
        end
        c = [mean(IV_data(1,:,:),3);mean(IV_data(2,:,:),3)];
        average = cat(3,average,c);
        c = std(IV_data,0,3); c = c(2,:);
        st_dev = cat(3,st_dev,c);
    end
end