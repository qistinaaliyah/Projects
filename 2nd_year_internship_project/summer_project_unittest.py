import unittest
import ansys.motorcad.core as pymotorcad

class TestMotorCad(unittest.TestCase):
    def setUp(self):
        self.mcApp = pymotorcad.MotorCAD()
        self.mcApp.load_from_file(r'C:\Users\qistinatmp\Desktop\project.mot')

    def test_get_all_node_numbers(self):
        user_func = get_all_node_numbers(350)
        self.assertEqual(user_func.node_number, 350)

    def test_axial_slices_number(self):
        self.mcApp.set_variable("ThermalCalcType", 0)
        self.mcApp.do_steady_state_analysis()
        AXIALSLICESNUMBER = self.mcApp.get_variable("AxialSliceDefinition")
        Axial_slices_number = (2*(AXIALSLICESNUMBER) + 1)
        self.assertGreater(Axial_slices_number, 0)
        
    def test_no_of_cuboid(self):
        No_Of_Cuboid = self.mcApp.get_variable("NumberOfCuboids_LossModel_Lab")
        NoOfCuboid = (No_Of_Cuboid)
        self.assertGreater(NoOfCuboid, 0)

if __name__ == '__main__':
    unittest.main()