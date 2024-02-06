function fnames=getFileNames(fn)
    lg=length(fn);
    fnames=cell(lg,1);
    for i=1:lg,
        fnames{i}=fn(i).name;
    end