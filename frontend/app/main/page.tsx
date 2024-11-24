"use client";

import React, { useRef, useState } from "react";

const Main: React.FC = () => {
  const [fileName, setFileName] = useState<string | null>(null);
  const [filePath, setFilePath] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files[0]) {
      const file = event.target.files[0];

      if (file.type != "text/csv" && file.type != "application/vnd.ms-excel") {
        alert("Please upload a valid CSV file.");
        event.target.value = "";
        return;
      }
      setFileName(file.name);
      setFilePath(file.webkitRelativePath);
    //   setFilePath(URL.createObjectURL(file));
    }
  };

  const handleDrop = (event: React.DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    const file = event.dataTransfer.files[0];
    if (file) {
      if (file.type == "text/csv") {
        setFileName(file.name);
      } else {
        alert("Please upload a valid CSV file.");
      }
    }
  };

  const handleDragOver = (event: React.DragEvent<HTMLDivElement>) => {
    event.preventDefault();
  };

  const triggerFileInput = () => {
    if (fileInputRef.current) {
      fileInputRef.current.click();
    }
  };

  const handleSubmit = async () => {
    if (
      !fileInputRef.current ||
      !fileInputRef.current.files ||
      !fileInputRef.current.files[0] ||
      !fileName
    ) {
      alert("Please upload a file before submitting.");
      return;
    }
    // const file = fileInputRef.current.files[0];

    // Create a FormData object to handle file upload
    // const formData = new FormData();
    // formData.append("file", file);

    console.log(fileName);
    console.log(filePath);
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_SERVER_URL}/toJson`,
        {
          method: "POST",
          body: filePath,
        }
        
      );

      if (!response.ok) {
        throw new Error(`Error: ${response.statusText}`);
      }

      const data = await response.json();
      alert(`File converted successfully! Output Path: ${data.outputPath}`);
    } catch (error) {
      console.error("Error uploading file:", error);
      alert("There was an error uploading the file.");
    }

    // Logic to handle the submission (e.g., call an API)
    alert("File submitted successfully!");
  };

  return (
    <div>
      <h1 className="text-7xl mt-12 font-bold text-center">
        Your Data <span className="text-10xl text-[#F37172]">Go</span>es Here
      </h1>
      <div className="flex flex-col justify-start mt-44 items-center min-h-screen">
        <div className="flex flex-col gap-6 items-center">
          {/* File upload area */}
          <div
            onDrop={handleDrop}
            onDragOver={handleDragOver}
            onClick={triggerFileInput}
            className="border-2 border-dashed border-[#F37172] rounded-md p-6 text-center w-96 h-28 cursor-pointer"
          >
            {fileName ? (
              <p className="text-green-600">File Uploaded: {fileName}</p>
            ) : (
              <p>Drag and drop your file, or click to select a file.</p>
            )}

            <input
              type="file"
              onChange={handleFileUpload}
              className="hidden"
              ref={fileInputRef}
            />
          </div>

          {/* Submit Button */}
          <button
            onClick={handleSubmit}
            className="mt-6 px-4 py-2 bg-[#F37172] text-white font-bold rounded-md"
          >
            Submit
          </button>
        </div>
      </div>
    </div>
  );
};

export default Main;
