

export default function Home() {
  return (
    <div className="flex items-center justify-between h-screen bg-white font-montserrat">
      <div className="absolute top-0 left-0 p-6 text-3xl font-bold text-gray-800">
        NextGoGen<span className="text-[#F37172] rounded-full text-4xl">.</span>
      </div>

      <div className="flex flex-col gap-12 pl-20 w-1/2">
        <h1 className="text-8xl font-bold text-gray-800">Make learning Fun!</h1>
        <h2 className="text-2xl font-medium text-gray-600">Lorem ipsum dolor, sit amet consectetur adipisicing elit. Ullam quo vel iusto consequuntur quia exercitationem, culpa ducimus ratione eum officiis magni omnis odit quasi dolorum dolor aperiam tempore id. Provident.</h2>
        <button className="bg-[#F37172] text-white px-8 py-3 rounded-lg hover:bg-blue-700 w-fit">
          Get Started
        </button>
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