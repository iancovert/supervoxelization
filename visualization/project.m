function projection = project(frame)
        % Create projections
        frame = frame - min(frame(:));
        frame = frame / max(frame(:));
        projX = squeeze(max(frame,[],1));
        projY = squeeze(max(frame,[],2));
        projZ = squeeze(max(frame,[],3));

        % Create figure with 3 subplots
        fh = figure;
        subplot(2, 2, 1); imshow(projX);
        subplot(2, 2, 2); imshow(projY);
        subplot(2, 2, 3); imshow(projZ);

        % Save and return figure
        projection = saveFig(fh);
        delete(fh);