function iids=RemoveDirect(iids)

for i=numel(iids):-1:1
    
%     imageFile=fullfile('',iids(i).name);
%     [fpathstr, fname] = fileparts(imageFile); %, fext
    
    if ( iids(i).isdir )
        iids(i)=[];
    end
    
end
