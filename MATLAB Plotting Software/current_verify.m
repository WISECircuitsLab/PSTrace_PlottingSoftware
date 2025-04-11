function [out] = current_verify (in)
%input is nx1 cell array
    out = zeros(1,length(in));
    for x = 1:length(in)
        input = strsplit(in{x});
        output = '';
        if input{end} == "mA"
            output = str2double(input{1})*10^(-3);
        end
        if input{end} == "uA"
            output = str2double(input{1})*10^(-6);
        end
        out(x) = output;
    end
end