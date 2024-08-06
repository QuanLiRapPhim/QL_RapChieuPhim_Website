using QL_RapChieuPhim.Models;
using System.Collections.Generic;
using System.Linq;

public class CollaborativeFiltering
{
    private List<PhimInfo> _phimInfos;
    private List<DanhGiaPhim> _danhGiaPhims;

    public CollaborativeFiltering(List<PhimInfo> phimInfos, List<DanhGiaPhim> danhGiaPhims)
    {
        _phimInfos = phimInfos;
        _danhGiaPhims = danhGiaPhims;
    }

    public List<PhimInfo> Recommend(int maPhim)
    {
        var selectedPhim = _phimInfos.FirstOrDefault(p => p.MaPhim == maPhim);
        if (selectedPhim == null)
        {
            return new List<PhimInfo>();
        }

        var similarPhims = _phimInfos.Where(p => p.TheLoai == selectedPhim.TheLoai)
            .OrderByDescending(p => p.TenPhim)
            .Take(5)
            .ToList();

        return similarPhims;
    }
}