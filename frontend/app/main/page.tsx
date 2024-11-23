"use client";

import React, { useRef, useState } from "react";

const Main: React.FC = () => {
    const [fileName, setFileName] = useState<string | null>(null);
    const fileInputRef = useRef<HTMLInputElement>(null);

    const handleFileUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
        if (event.target.files && event.target.files[0]) {
            const file = event.target.files[0];
            if (file.type === "text/csv") {
                setFileName(file.name);
            } else {
                alert("Please upload a valid CSV file.");
            }
        }
    };

    const handleDrop = (event: React.DragEvent<HTMLDivElement>) => {
        event.preventDefault();
        const file = event.dataTransfer.files[0];
        if (file) {
            if (file.type === "text/csv") {
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

    return (
        <div>
            <h1 className="text-7xl mt-12 font-bold text-center">
                Your Data <span className="text-10xl text-[#F37172]">Go</span>es Here
            </h1>
            <div className="flex flex-col justify-start mt-44 items-center min-h-screen">
                <div className="flex flex-col md:flex-row gap-4 items-center">

                    <input
                        type="text"
                        placeholder="Enter some text..."
                        className="border border-gray-300 rounded-md p-2 w-96 h-28"
                    />


                    <div
                        onDrop={handleDrop}
                        onDragOver={handleDragOver}
                        onClick={triggerFileInput}
                        className="border-2 border-dashed border-[#F37172] rounded-md p-6 text-center w-96 h-28 cursor-pointer"
                    >
                        {fileName ? (
                            <p className="text-green-600">File Uploaded: {fileName}</p>
                        ) : (
                            <p>Drag and drop your CSV file here, or click to select a file.</p>
                        )}

                        <input
                            type="file"
                            accept=".csv"
                            onChange={handleFileUpload}
                            className="hidden"
                            ref={fileInputRef}
                        />
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Main;
