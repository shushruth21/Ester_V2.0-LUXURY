import React, { useState, useCallback } from 'react';
import { useDropzone } from 'react-dropzone';
import { Upload, X, Image as ImageIcon, AlertCircle, CheckCircle } from 'lucide-react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Progress } from '@/components/ui/progress';
import { useUploadImage, useImageUploadSession, useUpdateUploadSession } from '@/hooks/useImages';
import { useToast } from '@/hooks/use-toast';

interface ImageUploaderProps {
  modelId?: string;
  categoryId?: string;
  onUploadComplete?: () => void;
  maxFiles?: number;
  allowMultiple?: boolean;
}

interface FileWithPreview extends File {
  preview: string;
  altText?: string;
  isPrimary?: boolean;
  displayOrder?: number;
}

export const ImageUploader: React.FC<ImageUploaderProps> = ({
  modelId,
  categoryId,
  onUploadComplete,
  maxFiles = 10,
  allowMultiple = true,
}) => {
  const [files, setFiles] = useState<FileWithPreview[]>([]);
  const [uploading, setUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [sessionId] = useState(() => crypto.randomUUID());
  
  const { toast } = useToast();
  const uploadImageMutation = useUploadImage();
  const createSessionMutation = useImageUploadSession();
  const updateSessionMutation = useUpdateUploadSession();

  const onDrop = useCallback((acceptedFiles: File[]) => {
    const newFiles = acceptedFiles.slice(0, maxFiles - files.length).map((file) => 
      Object.assign(file, {
        preview: URL.createObjectURL(file),
        altText: file.name.replace(/\.[^/.]+$/, ""), // Remove extension for default alt text
        isPrimary: files.length === 0, // First file is primary by default
        displayOrder: files.length,
      })
    );
    
    setFiles(prev => [...prev, ...newFiles]);
  }, [files.length, maxFiles]);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.jpeg', '.jpg', '.png', '.webp', '.gif']
    },
    multiple: allowMultiple,
    maxFiles: maxFiles,
  });

  const removeFile = (index: number) => {
    setFiles(prev => {
      const newFiles = prev.filter((_, i) => i !== index);
      // Revoke object URL to prevent memory leaks
      URL.revokeObjectURL(prev[index].preview);
      
      // Reassign display order and ensure we have a primary image
      return newFiles.map((file, i) => ({
        ...file,
        displayOrder: i,
        isPrimary: i === 0 && newFiles.length > 0,
      }));
    });
  };

  const updateFileMetadata = (index: number, updates: Partial<FileWithPreview>) => {
    setFiles(prev => prev.map((file, i) => {
      if (i === index) {
        return { ...file, ...updates };
      }
      // If this file is being set as primary, unset others
      if (updates.isPrimary && file.isPrimary) {
        return { ...file, isPrimary: false };
      }
      return file;
    }));
  };

  const handleUpload = async () => {
    if (files.length === 0) return;

    setUploading(true);
    setUploadProgress(0);

    try {
      // Create upload session
      await createSessionMutation.mutateAsync({
        sessionId,
        totalFiles: files.length,
        metadata: { modelId, categoryId },
      });

      let completed = 0;
      let failed = 0;

      // Upload files sequentially to avoid overwhelming the server
      for (const file of files) {
        try {
          await uploadImageMutation.mutateAsync({
            file,
            modelId,
            categoryId,
            altText: file.altText,
            isPrimary: file.isPrimary,
            displayOrder: file.displayOrder,
          });
          completed++;
        } catch (error) {
          console.error(`Failed to upload ${file.name}:`, error);
          failed++;
        }
        
        setUploadProgress((completed + failed) / files.length * 100);
      }

      // Update upload session
      await updateSessionMutation.mutateAsync({
        sessionId,
        updates: {
          completed_files: completed,
          failed_files: failed,
          status: failed === 0 ? 'completed' : 'failed',
        },
      });

      if (completed > 0) {
        toast({
          title: "Upload Successful",
          description: `${completed} image(s) uploaded successfully.`,
        });
        
        // Clean up
        files.forEach(file => URL.revokeObjectURL(file.preview));
        setFiles([]);
        onUploadComplete?.();
      }

      if (failed > 0) {
        toast({
          title: "Some uploads failed",
          description: `${failed} image(s) failed to upload.`,
          variant: "destructive",
        });
      }

    } catch (error) {
      toast({
        title: "Upload Failed",
        description: error instanceof Error ? error.message : "Failed to upload images",
        variant: "destructive",
      });
    } finally {
      setUploading(false);
      setUploadProgress(0);
    }
  };

  return (
    <Card className="p-6">
      <div className="space-y-6">
        {/* Dropzone */}
        <div
          {...getRootProps()}
          className={`border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition-colors ${
            isDragActive
              ? 'border-primary bg-primary/5'
              : 'border-muted-foreground/25 hover:border-primary/50'
          }`}
        >
          <input {...getInputProps()} />
          <Upload className="mx-auto h-12 w-12 text-muted-foreground mb-4" />
          {isDragActive ? (
            <p className="text-lg">Drop the images here...</p>
          ) : (
            <div>
              <p className="text-lg mb-2">
                Drag & drop images here, or click to select
              </p>
              <p className="text-sm text-muted-foreground">
                Supports JPEG, PNG, WebP, GIF (max {maxFiles} files)
              </p>
            </div>
          )}
        </div>

        {/* File Preview and Metadata */}
        {files.length > 0 && (
          <div className="space-y-4">
            <h3 className="text-lg font-semibold">
              Selected Images ({files.length})
            </h3>
            
            <div className="grid gap-4">
              {files.map((file, index) => (
                <Card key={index} className="p-4">
                  <div className="flex gap-4">
                    {/* Image Preview */}
                    <div className="relative w-24 h-24 flex-shrink-0">
                      <img
                        src={file.preview}
                        alt="Preview"
                        className="w-full h-full object-cover rounded"
                      />
                      <Button
                        variant="destructive"
                        size="sm"
                        className="absolute -top-2 -right-2 h-6 w-6 p-0"
                        onClick={() => removeFile(index)}
                      >
                        <X className="h-4 w-4" />
                      </Button>
                    </div>

                    {/* Metadata Form */}
                    <div className="flex-1 space-y-3">
                      <div>
                        <Label htmlFor={`alt-${index}`}>Alt Text</Label>
                        <Input
                          id={`alt-${index}`}
                          value={file.altText || ''}
                          onChange={(e) => updateFileMetadata(index, { altText: e.target.value })}
                          placeholder="Describe this image..."
                        />
                      </div>

                      <div className="flex items-center space-x-2">
                        <Switch
                          id={`primary-${index}`}
                          checked={file.isPrimary || false}
                          onCheckedChange={(checked) => updateFileMetadata(index, { isPrimary: checked })}
                        />
                        <Label htmlFor={`primary-${index}`}>Primary Image</Label>
                      </div>

                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <ImageIcon className="h-4 w-4" />
                        {file.name} ({(file.size / 1024 / 1024).toFixed(2)} MB)
                      </div>
                    </div>
                  </div>
                </Card>
              ))}
            </div>

            {/* Upload Progress */}
            {uploading && (
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-sm">Uploading images...</span>
                  <span className="text-sm">{Math.round(uploadProgress)}%</span>
                </div>
                <Progress value={uploadProgress} />
              </div>
            )}

            {/* Upload Button */}
            <Button
              onClick={handleUpload}
              disabled={uploading || files.length === 0}
              className="w-full"
            >
              {uploading ? (
                <>
                  <Upload className="mr-2 h-4 w-4 animate-spin" />
                  Uploading...
                </>
              ) : (
                <>
                  <Upload className="mr-2 h-4 w-4" />
                  Upload {files.length} Image{files.length !== 1 ? 's' : ''}
                </>
              )}
            </Button>
          </div>
        )}
      </div>
    </Card>
  );
};

export default ImageUploader;