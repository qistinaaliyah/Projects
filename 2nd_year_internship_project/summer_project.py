import ansys.motorcad.core as pymotorcad

mcApp = pymotorcad.MotorCAD()
    # uncomment this line if using external Python IDE
mcApp.load_from_file(r'C:\Users\qistinatmp\Desktop\project\project.mot')


def main():
    mcApp.display_screen("scripting")
    # The function below allow the user to enter the required value of node numbers
    # according to the type of component needed

    # The value of the node number entered must be the node number of the central component
    # of the circuit (the lowest value of the node number of the component)
    user_func = get_all_node_numbers(350)

    # This class is written to get all node numbers of the same component
    # required by the user when the user enter the node number above


class get_all_node_numbers:

    def __init__(self, node_number):
        self.node_number = node_number

        # the script below refers to setting the thermal calculation type to steady state
        # and do the steady state analysis in order to require the thermal network node
        # circuit

        # The number of axial slices that have been set by the user are required for the
        # calculation purposes below
        print("Calculating the number of axial slices")
        mcApp.set_variable("ThermalCalcType", 0)
        mcApp.do_steady_state_analysis()
        axialslicesnumber = mcApp.get_variable("AxialSliceDefinition")
        Axial_slices_number = (2 * axialslicesnumber + 1)
        mcApp.show_message("The axial slices numbers = " + str(Axial_slices_number))
        print(Axial_slices_number)

        # The script below refers to calculating the number of cuboids of the winding in the
        # thermal node network for calculation purposes to obtain the other node numbers
        print("Calculating the number of cuboids")
        No_Of_Cuboid = mcApp.get_variable("NumberOfCuboids_LossModel_Lab")
        NoOfCuboid = (No_Of_Cuboid)
        mcApp.show_message("The numbers of cuboids = " + str(NoOfCuboid))

        total_node_numbers = []
        for axial in range(Axial_slices_number):
            for cuboid in range(NoOfCuboid):
                node_numbers = mcApp.get_offset_node_number(node_number, axial + 1, cuboid + 1)
                total_node_numbers.append(node_numbers)
                total_node_numbers.sort()

        print(f'Total node numbers {total_node_numbers}')
        mcApp.show_message("All node numbers = " + str(total_node_numbers))


main()  