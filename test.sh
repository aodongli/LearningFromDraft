for num in 4500 5000; do
    python translate.py --decode --model translate.ckpt-${num} < res > res${num}
    echo "After \"${num}\" updates, the BLEU is:" >> test_info
    perl multi-bleu.perl ./data/dev.ft < res${num} >> test_info
done
