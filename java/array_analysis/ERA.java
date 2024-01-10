import ucar.nc2.NetcdfFiles;
import ucar.nc2.NetcdfFile;
import ucar.nc2.Variable;
import ucar.ma2.Array;

public class ERA {
  public static void main(String[] args) {
    try {
      String filePath = "/home/anikfal/extra_codes/javacodes/ncFiles/era5.nc";
      NetcdfFile ncFile = NetcdfFiles.open(filePath);
      Variable d2m = ncFile.findVariable("d2m");
      Array d2m_arr = d2m.read();
      Array newd2m_arr = ncFile.readSection("d2m");

      System.out.println(d2m.getDimensions());
      int[] origin = { 0, 0, 1 };
      int[] size = { 2, 3, 5 };
      Array subsetData = d2m.read(origin, size);
      System.out.println(subsetData);

    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }
}