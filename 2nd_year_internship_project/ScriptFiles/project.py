# Need to import pymotorcad to access Motor-CAD
import ansys.motorcad.core as pymotorcad

mcApp = pymotorcad.MotorCAD()
def main():
    user_func = get_all_node_numbers(350)
    
class get_all_node_numbers:

    def __init__(self, node_number):
        self.node_number = node_number
             
        
        print("Calculating the number of axial slices")
        mcApp.set_variable("ThermalCalcType", 0)
        mcApp.do_steady_state_analysis()
        AXIALSLICESNUMBER = mcApp.get_variable("AxialSliceDefinition")
        Axial_slices_number = (2*(AXIALSLICESNUMBER) + 1)
        mcApp.show_message("The axial slices numbers = " + str(Axial_slices_number))
        
 
        print("Calculating the number of cuboids")
        No_Of_Cuboid = mcApp.get_variable("NumberOfCuboids_LossModel_Lab")
        NoOfCuboid = (No_Of_Cuboid)
        mcApp.show_message("The numbers of cuboids = " + str(NoOfCuboid))
      
        total_node_numbers = []
        for axial in range(Axial_slices_number): 
            for cuboid in range(NoOfCuboid):
                node_numbers = mcApp.get_offset_node_number(node_number, axial+1, cuboid+1)
                total_node_numbers.append(node_numbers)

        print(f'Total node numbers {total_node_numbers.sort()}')
        mcApp.show_message("All node numbers = " + str(total_node_numbers))    