﻿using MMRando.Constants;
using MMRando.Models;
using MMRando.Models.Rom;

namespace MMRando.Utils
{

    public static class ObjUtils
    {

        public static int GetObjSize(int obj)
        {
            int f = RomUtils.GetFileIndexForWriting(Addresses.ObjTable);
            int basea = Addresses.ObjTable - RomData.MMFileList[f].Addr;
            return (int)(ReadWriteUtils.Arr_ReadU32(RomData.MMFileList[f].Data.ReadonlyData, basea + (obj * 8) + 4)
                - ReadWriteUtils.Arr_ReadU32(RomData.MMFileList[f].Data.ReadonlyData, basea + (obj * 8)));
        }

        public static void InsertObj(byte[] obj, int replace)
        {
            int f = RomUtils.GetFileIndexForWriting(Addresses.ObjTable);
            int basea = Addresses.ObjTable - RomData.MMFileList[f].Addr;
            uint replaceaddr = ReadWriteUtils.Arr_ReadU32(RomData.MMFileList[f].Data.ReadonlyData, basea + (replace * 8));
            int objf = RomData.MMFileList.FindIndex(u => u.Addr == replaceaddr);
            if (objf == -1)
            {
                return;
            };
            if (obj.Length > (RomData.MMFileList[objf].End - RomData.MMFileList[objf].Addr))
            {
                MMFile newfile = new MMFile();
                newfile.Addr = RomData.MMFileList[RomData.MMFileList.Count - 1].End;
                newfile.End = newfile.Addr + obj.Length;
                newfile.IsCompressed = true;
                newfile.WasEdited = true;
                newfile.Data = new ChangeTrackingArray<byte>(new byte[obj.Length]);
                newfile.Data.Write(0, obj);
                RomData.MMFileList[objf].Cmp_Addr = -1;
                RomData.MMFileList[objf].Cmp_End = -1;
                RomData.MMFileList[objf].Data = null;
                RomData.MMFileList[objf].IsCompressed = false;
                RomData.MMFileList.Add(newfile);
                ReadWriteUtils.Arr_WriteU32(RomData.MMFileList[f].Data, basea + (replace * 8), (uint)newfile.Addr);
                ReadWriteUtils.Arr_WriteU32(RomData.MMFileList[f].Data, basea + (replace * 8) + 4, (uint)newfile.End);
            }
            else
            {
                RomData.MMFileList[objf].Data = new ChangeTrackingArray<byte>(obj);
                RomData.MMFileList[objf].WasEdited = true;
            }
        }
    }

}