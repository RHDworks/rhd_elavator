import React, { useState } from 'react';
import { Text, SimpleGrid, ScrollArea, Paper, rem, Transition, Box, Divider, useMantineTheme, alpha, Button } from '@mantine/core';
import { useNuiEvent } from '../hooks/useNuiEvent';
import { useExitListener } from '../hooks/useExitListener';

import type { ElevatorProps } from '../types';
import { fetchNui } from '../utils/fetchNui';

const App: React.FC = () => {
    const theme = useMantineTheme()

    const [visible, setVisible] = useState(false);
    const [elevatorData, setElevatorData] = useState<ElevatorProps|null>(null)

    useNuiEvent('setVisible', (data: {visible: boolean, elevatorData:ElevatorProps}) => {
        setVisible(data.visible);

        if (data.elevatorData) {
            setElevatorData(data.elevatorData);
        }
    })

    const handleClose = (state?:boolean) => {
        setVisible(state || false);
    }

    useExitListener(handleClose);

    const executeLift = (floor: number) => {
        fetchNui('rhd_elevator:client:execute', {floor: floor}, {
            data: true
        })
        handleClose();
    }

    return (
        <Transition
            mounted={visible}
            transition="fade-left"
            duration={400}
            timingFunction="ease"
        >
            {(transStyles) => (
                <Box
                    style={{
                        position: 'fixed',
                        right: rem(20),
                        top: '50%',
                        transform: 'translateY(-50%)',
                        width: rem(280),
                        height: rem(350),
                        zIndex: 1000,
                    }}
                >
                    <Paper shadow="lg" p="sm" radius="md" withBorder style={{
                            ...transStyles,
                            height: rem(400),
                            backgroundColor: alpha(theme.colors.dark[8], 0.8)
                        }}
                    >
                        <Text
                            fw={700}
                            size='lg'
                            c='rhd.7'
                            style={{
                                alignItems: 'center',
                                justifyContent: 'center',
                                display: 'flex',
                                flexDirection: 'column',
                            }}
                        >
                            {(elevatorData?.id || 'Broken Elevator').toUpperCase()}
                        </Text>

                        <Divider my='md' />

                        <ScrollArea h={310} scrollbarSize={1}>
                            <SimpleGrid cols={2} spacing='8px'>
                                {elevatorData?.floor.map((val) => (
                                    <Button
                                        variant='light'
                                        color='rhd.6'
                                        size='20px'
                                        h={80}
                                        onClick={() => {
                                            executeLift(val.index)
                                        }}
                                        disabled = {val.disable}
                                    >
                                        {val.label || val.index}
                                    </Button>
                                ))}
                            </SimpleGrid>
                        </ScrollArea>
                    </Paper>
                </Box>
            )}
        </Transition>
    )
}

export default App