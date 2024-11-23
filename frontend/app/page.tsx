import Link from "next/link"

export default function Home() {
  return (
    <div className="flex items-center justify-between h-screen bg-white font-montserrat">
      <div className="absolute top-0 left-0 p-6 text-3xl font-bold text-gray-800">
        NextGoGen<span className="text-[#F37172] rounded-full text-4xl">.</span>
      </div>

      <div className="flex flex-col gap-12 pl-20 w-1/2">
        <h1 className="text-8xl font-bold text-gray-800">Make learning Fun!</h1>
        <h2 className="text-2xl font-medium text-gray-600">Transform any data, any format—databases, CSV, JSON, and more—effortlessly. Your go-to solution for seamless data processing!</h2>
        <Link href="/main" className="bg-[#F37172] text-white px-8 py-3 rounded-lg w-fit">
          Get Started
        </Link>
      </div>

      <div className="pr-40">
        <img
          src="/image.png"
          alt="Placeholder"
          className="w-96 h-96 object-cover rounded-lg"
        />
      </div>
    </div>
  );
}