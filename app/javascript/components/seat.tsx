import * as React from "react"

interface SeatProps {
  seatNumber: number
  initialStatus: string
}

const Seat = ({
  seatNumber,
  initialStatus,
}: SeatProps): React.ReactElement => {
  const [status, setStatus] = React.useState(initialStatus) 

  function changeState(): void {
    if (status === "held") {
      setStatus("unsold")
    } else {
      setStatus("held")
    }
  }

  function stateDisplayClass(): string {
    if (status === "held") {
      return "bg-green-500"
    } else {
      return "bg-white hover:bg-blue-300"
    }
  }

  const cssClass = "p-4 m-2 border-black border-4 text-lg"

  return (
    <td>
      <span
        className={`${cssClass} ${stateDisplayClass()}`}
        onClick={changeState}>
        {seatNumber + 1}
      </span>
    </td>
  )
}

export default Seat
