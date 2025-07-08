export interface ElevatorData {
    index: number;
    label?:string;
    disable?: boolean
}

export interface ElevatorProps {
    id: string,
    floor: ElevatorData[]
}