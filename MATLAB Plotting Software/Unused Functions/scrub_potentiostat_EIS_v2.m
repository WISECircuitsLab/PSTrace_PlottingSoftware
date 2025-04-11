function [average,st_dev] = scrub_potentiostat_EIS(data)
    [n,d]=size(data);

    average = [];
    st_dev = [];
    for i = 1:n
        IV_data = [];
        count = 0;
        for j = 1:d
            if ~cellfun(@isempty,data(i,j))

                freq_values = table2array(data{i,j}(:,2));
                data_dropped = removevars(data{i,j},[1,2,8,9]); %remove logF & current range columns
                data_array = table2array(data_dropped);
                full_data_matrix_one = [freq_values data_array];

                if count==0
                    IV_data = full_data_matrix_one;
                else
                    IV_data = cat(3,IV_data,full_data_matrix_one);
                end
                count = count+1;
            end
        end
        average = cat(3,average,mean(IV_data,3));
        st_dev = cat(3,st_dev,std(IV_data,0,3));
    end
end