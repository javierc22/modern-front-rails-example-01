import * as React from "react"
import styled from "styled-components"

const stateColor = (status: string): string => {
  if (status === "unsold") {
    return "white"
  } else if (status === "held") {
    return "green"
  } else {
    return "red"
  }
}

interface SquareProps {
  status: string
  className?: string
}
const buttonClass = "p-4 m-2 border-black border-4 text-lg"

const ButtonSquare = styled.span.attrs({
  className: buttonClass,
})<SquareProps>`
  background-color: ${(props) => stateColor(props.status)};
  transition: all 1s ease-in-out;

  &:hover {
    background-color: ${(props) =>
      props.status === "unsold" ? "lightblue" : stateColor(props.status)};
  }
`

interface SeatProps {
  seatNumber: number
  status: string
  clickHandler: (seatNumber: number) => void
}

export const Seat = ({
  seatNumber,
  status,
  clickHandler,
}: SeatProps): React.ReactElement => {
  function changeState(): void {
    clickHandler(seatNumber)
  }

  return (
    <td>
      <ButtonSquare status={status} onClick={changeState}>
        {seatNumber + 1}
      </ButtonSquare>
    </td>
  )
}

export default Seat
