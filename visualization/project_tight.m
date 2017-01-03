function projection = project_tight(frame, border)
  if (nargin < 2)
    border = false;
  end

  % Create projections
  frame = frame - min(frame(:));
  frame = frame / max(frame(:));
  projX = squeeze(max(frame,[],1));
  projY = squeeze(max(frame,[],2));
  projZ = squeeze(max(frame,[],3));

  % Create full image
  if (border)
    projection = ones(size(projY, 1) + size(projX, 1) + 1, size(projY, 2) + size(projZ, 2) + 1);
    projection(1:size(projY, 1), 1:size(projY, 2)) = projY;
    projection((size(projY, 1) + 2):end, 1:size(projX, 2)) = projX;
    projection(1:size(projZ, 1), (size(projY, 2) + 2):end) = projZ;
    projection((size(projY, 1) + 2):end, (size(projY, 2) + 2):end) = 0;
  else
    projection = zeros(size(projY, 1) + size(projX, 1), size(projY, 2) + size(projZ, 2));
    projection(1:size(projY, 1), 1:size(projY, 2)) = projY;
    projection((size(projY, 1) + 1):end, 1:size(projX, 2)) = projX;
    projection(1:size(projZ, 1), (size(projY, 2) + 1):end) = projZ;
  end