%% inputs
prompt1='Give a dimension ';
dim=input(prompt1);
numOfSud=40;    %the initial population has 40 sudoku puzzles

%% initial population
sudList= {[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[];[]};   

sudoku={[],[]};

for i=1:numOfSud                            % numOfSud is the population
    for j=1:dim                             % dim is the dimension of the puzzle
        vec=randperm(dim);                  % create a vector with <dim> elements
        sudList{i} = [sudList{i}, vec];     % create the sudoku. Put <dim> vectors back-to-back
    end
    sudoku{i} = vec2mat(sudList{i},dim);    % convert the vector to matrix
end

%% fitness
sudFit = zeros (1,numOfSud);                % sudFit declares how good is the puzzle
error = zeros (numOfSud, dim);              % error is the absolute value of the difference between the real ...
                                            % ... and the desired sum of each column
desiredSum = 0;
for i=1:dim
    desiredSum = desiredSum + i;            % desiredSum is the sum of 1,2,...,dim
end

for sud=1:numOfSud
    for col=1:dim
        sumOfCol = 0;
        for row=1:dim
            sumOfCol = sumOfCol + sudoku{sud}(row,col);
        end
        error(sud,col) = abs(desiredSum - sumOfCol);
    end
    
    sudFit(1,sud) = sum(error(sud,:));
end

checkCor =0 ;                               % checkCor is 0 if there aren't good sudokus
for i=1:numOfSud
    if (sudFit(1,i) == 0)                   % if there is at least on it has its position in initial population
        checkCor = i;                                                            
    end
end


%% mutation
generation = 1;
while (checkCor == 0)
    
   generation = generation +1;              % every loop is a new generation
   
   for sud=1:numOfSud
      [val,loc] = max(error(sud,:));
      
      if (loc == dim)                       % loc is the column with max error
          loc2 = loc-1;                     % loc2 is a column-neighbour of loc 
      else
          loc2 = loc+1;
      end
      

      randRow = randi (1,dim);              % choose a random row                                            
                                            % swap the elements of the same row
      temp = sudoku{sud}(randRow,loc);
      sudoku{sud}(randRow,loc) = sudoku{sud}(randRow,loc2);
      sudoku{sud}(randRow,loc2) = temp;  
      
      
   end
   
   % fitness
    sudFit = zeros (1,numOfSud);
    error = zeros (numOfSud, dim);

    for sud=1:numOfSud
        for col=1:dim
            sumOfCol = 0;
            for row=1:dim
                sumOfCol = sumOfCol + sudoku{sud}(row,col);
            end
            error(sud,col) = abs(desiredSum - sumOfCol);
        end

        sudFit(1,sud) = sum(error(sud,:));
    end

    checkCor =0 ;
    for i=1:numOfSud
        if (sudFit(1,i) == 0)
            checkCor = i;
        end
    end
   
end

fprintf ('generation: %d \n', generation);

disp(sudoku{checkCor});